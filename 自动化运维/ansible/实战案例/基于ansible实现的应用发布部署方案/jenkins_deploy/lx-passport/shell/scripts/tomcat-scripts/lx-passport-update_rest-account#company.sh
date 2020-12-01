#!/bin/bash
#description: common update for tomcat application(only can be used by TRC)...
#version: V2.1
#auth: by zhengxin20180209
#email: hzzxin@tairanchina.com

SOURCE="/data"
APP_NAME="account#company"
PKG_NAME="${APP_NAME}.war"
PKG_SOURCE="${SOURCE}/deploy"
BACKUP_SOURCE="${SOURCE}/backup"
UPDATE_TEMP_SOURCE="${SOURCE}/update"
TOMCAT_DIR="/usr/local/tomcat"
TOMCAT_SCRIPT="/etc/init.d/tomcat8080"
TEMP_DIR="${UPDATE_TEMP_SOURCE}/pkg/tomcat_tmp"
APP_INSTALL_FILE="${TEMP_DIR}/${APP_NAME}.txt"
LOCK_FILE="/tmp/tomcat.lock"
CHECK_SCRIPT="/usr/local/weihu/check_url"
USER="trcweb"
GROUP="trcweb"

##create directory
mkdir -p ${SOURCE}/{deploy,backup,update} 2>/dev/null
mkdir -p $TEMP_DIR 2>/dev/null
>$APP_INSTALL_FILE

##record pkg path to file
ls -1 ${TEMP_DIR} | grep "\<${PKG_NAME}\>-.*" | sort -rn | head -1 >$APP_INSTALL_FILE

##lock script
LOCK_SCRIPT() {
    if [ -e $LOCK_FILE ];then
        echo "lock has been exists,can't operate this script on multiuser-mode..."
        exit 1
    else
        touch $LOCK_FILE
        echo $$ >$LOCK_FILE
    fi
}

##解锁
UNLOCK_SCRIPT() {
    rm -f $LOCK_FILE
}

##check app_install file
CHECK_FILE() {
    if [ -f $APP_INSTALL_FILE ];then
        if [ ! -s $APP_INSTALL_FILE ];then
    	    echo "$APP_INSTALL_FILE is empty..."
            UNLOCK_SCRIPT
            exit 1
        fi
    else
        echo "$APP_INSTALL_FILE not exists..."
        UNLOCK_SCRIPT
        exit 1
    fi
}

##check tag version
CHECK_TAG_VER() {
    TAG_VERSION=$(echo ${1/*.war-/})
    if [ x"$TAG_VERSION" = x"" ];then
        echo "sorry,APP tag is empty..."
        UNLOCK_SCRIPT
        exit 1
    else
        if ! echo $TAG_VERSION | grep -E "^[[:digit:]]+$" &>/dev/null;then
            echo "${APP_NAME}: tag format is wrong..."
            UNLOCK_SCRIPT
            exit 1
        fi
    fi

    if ls -1 ${PKG_SOURCE}/${APP_NAME} | grep "^${TAG_VERSION}$" &>/dev/null;then
        echo "${APP_NAME}: this version has been updated,can't update again..."
        UNLOCK_SCRIPT
        exit 1
    fi        
}

##check app_package
CHECK_APP_PKG() {
    if [ -f ${TEMP_DIR}/$1 ];then
   	if [ ! -s ${TEMP_DIR}/$1 ];then
	    echo "${1} size is wrong..."
	    CHECK_CODE=1
        else
	    CHECK_CODE=0
    	fi
    else
        echo "${1} not exists..."
	CHECK_CODE=1
    fi
    return $CHECK_CODE
}


##backup app_package
BACKUP() {
    if [ ! -d ${PKG_SOURCE}/${APP_NAME}/$TAG_VERSION ];then
	 mkdir -p ${PKG_SOURCE}/${APP_NAME}/$TAG_VERSION
    fi
	 mv ${TEMP_DIR}/${1} ${PKG_SOURCE}/${APP_NAME}/$TAG_VERSION
	
	 if [ ! -d ${BACKUP_SOURCE}/${APP_NAME}/$TAG_VERSION ];then
	     mkdir -p ${BACKUP_SOURCE}/${APP_NAME}/$TAG_VERSION
	 fi
	
    if ! ls ${BACKUP_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION/* &>/dev/null;then
	 \cp -a -r  ${TOMCAT_DIR}/webapps/${APP_NAME} ${BACKUP_SOURCE}/${APP_NAME}/$TAG_VERSION
    fi
}


##update applications
UPDATE() {
    cd ${TOMCAT_DIR}/webapps
    sh $TOMCAT_SCRIPT stop
    x=1
    while((x<=3));do
       if ps -ef | grep \[j]ava | grep "[/]usr/local/tomcat/conf" &>/dev/null;then
           sh $TOMCAT_SCRIPT stop
       else
           break
       fi
    done
    APP_LINK="${PKG_NAME}"
    APP_DIR="${APP_NAME}"
    rm -rf $APP_LINK $APP_DIR
    ln -sf ${PKG_SOURCE}/${APP_DIR}/$TAG_VERSION/$1 $APP_LINK
    LINK_SOURCE=$(ls -l $APP_LINK | awk '{print $NF}')
    ##clean expired pkg(store 8 pkg for every project)
     #rm  -f  $(ls -1 -r ${PKG_SOURCE}/${APP_DIR}/*/${APP_LINK}-* | grep -v "${LINK_SOURCE}" | sed -n "8,\$p")
    rm  -rf  $(ls -1 -r ${PKG_SOURCE}/${APP_DIR}/*/${APP_LINK}-* | grep -v "${LINK_SOURCE}" | sed -n "8,\$p" | sed -r "s#(.*)/(.*)#\1#g")
}


##check tomcat service
CHECK_TOMCAT_SERVICE() {
    if [ -f $CHECK_SCRIPT ];then
        echo -e "\nnow,check tomcat application url:"
        bash $CHECK_SCRIPT
    else
	echo "check script not exists..."
        UNLOCK_SCRIPT
	exit 1
    fi
}


##start tomcat
START_TOMCAT() {
    chown -R ${USER}:${GROUP} $SOURCE $TOMCAT_DIR
    sh $TOMCAT_SCRIPT start
    sleep 10
    CHECK_TOMCAT_SERVICE
}


##deploy application
DEPLOY() {
    for j in $(cat $APP_INSTALL_FILE);do
        CHECK_APP_PKG ${j}
        if [ $CHECK_CODE -eq 0 ];then
            CHECK_TAG_VER ${j}
	    BACKUP ${j}
	    UPDATE ${j}
        fi
    done

    START_TOMCAT
}


##list last versions
LIST_VER() {
    if ls -l ${TOMCAT_DIR}/webapps/${PKG_NAME} &>/dev/null;then
        CURRENT_VER=$(ls -l ${TOMCAT_DIR}/webapps/${PKG_NAME} | awk '{print $NF}')
	echo -e "the applicaion current version as fllows: "
        echo -e "${CURRENT_VER}\n"
    else
	echo "no such application..."
        UNLOCK_SCRIPT
        exit 1
    fi

    if ! ls -1 ${PKG_SOURCE}/${APP_NAME}/*/${PKG_NAME}-* &>/dev/null;then
        echo "sorry,no last versions of this application..."
        UNLOCK_SCRIPT
	exit 1
    else
        LAST_VER=$(ls -1r ${PKG_SOURCE}/${APP_NAME}/*/${PKG_NAME}-* | grep -v "$CURRENT_VER")
        echo -e "last versions are as follows: "
	echo -e "${LAST_VER}\n"
    fi        	  
}


##rollback to the specified version
ROLLBACK() {
    LIST_VER &>/dev/null
    ROLLBACK_POINT="$1"

    if [ x"$ROLLBACK_POINT" = x"" ];then
	echo "you need to provide 1 parameters: [for example: rollback <rollback_point>]..."
        UNLOCK_SCRIPT
	exit 1
    fi

    if ! echo "$LAST_VER" | grep "$ROLLBACK_POINT" &>/dev/null;then
	echo "rollback point not exists..."
        UNLOCK_SCRIPT
	exit 1
    else
	echo "now,[${APP_NAME}] starting rollback to [$ROLLBACK_POINT]: "
        sh $TOMCAT_SCRIPT stop
        x=1
        while((x<=3));do
            if ps -ef | grep \[j]ava | grep "[/]usr/local/tomcat/conf" &>/dev/null;then
		sh $TOMCAT_SCRIPT stop
            else
		break
            fi
	done
        sleep 10
        rm -rf ${TOMCAT_DIR}/webapps/${APP_NAME}
        rm -f ${TOMCAT_DIR}/webapps/${PKG_NAME}
        ln -s $ROLLBACK_POINT ${TOMCAT_DIR}/webapps/${PKG_NAME}
    fi   
    START_TOMCAT
}

##main
LOCK_SCRIPT

case $1 in
deploy)
    CHECK_FILE
    DEPLOY
    ;;
list)
    LIST_VER
    ;;
rollback)
    ROLLBACK $2
    ;;
*)
    echo "Usage: $0 {deploy | list | rollback <rollback_point>}..."
    UNLOCK_SCRIPT
    exit 1
    ;;
esac

##clear temp directory
cd $TEMP_DIR
rm -f $(ls -1 ${TEMP_DIR}/ | grep "${APP_NAME}\..*")

##clear lock file
UNLOCK_SCRIPT
