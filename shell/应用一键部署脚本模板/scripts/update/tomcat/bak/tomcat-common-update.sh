#!/bin/bash
#description: common update for all tomcat application(only can be used by TRC)...
#version: V2.1
#auth: by zhengxin20180209
#email: hzzxin@tairanchina.com

DATE=$(date +%Y%m%d_%H%M%S)
SOURCE=/data
PKG_SOURCE=${SOURCE}/deploy
BACKUP_SOURCE=${SOURCE}/backup
UPDATE_TEMP_SOURCE=${SOURCE}/update
TOMCAT_DIR=/usr/local/tomcat
TOMCAT_SCRIPT=/etc/init.d/tomcat8080
TEMP_DIR=${UPDATE_TEMP_SOURCE}/pkg/tomcat_tmp
APP_INSTALL_FILE=${TEMP_DIR}/pkg.txt
CHECK_SCRIPT=/usr/local/weihu/check_url
USER=trcweb
GROUP=trcweb

##create directory
mkdir -p ${SOURCE}/{deploy,backup,update} 2>/dev/null
mkdir -p $TEMP_DIR 2>/dev/null
>$APP_INSTALL_FILE

##record pkg path to file
ls -1 ${TEMP_DIR} | grep -v ".*\.txt" >$APP_INSTALL_FILE

##check app_install file
CHECK_FILE() {
    if [ -f $APP_INSTALL_FILE ];then
        if [ ! -s $APP_INSTALL_FILE ];then
    	    echo "$APP_INSTALL_FILE is empty..."
            exit 1
        fi
    else
        echo "$APP_INSTALL_FILE not exists..."
        exit 1
    fi
}

##check tag version
CHECK_TAG_VER() {
    APP_SERVICE_NAME=$(echo ${1/\.war*/})   
    TAG_VERSION=$(echo ${1/*.war-/})
    if [ x"$TAG_VERSION" = x"" ];then
        echo "sorry,tag is empty..."
        exit 1
    else
        if ! echo $TAG_VERSION | grep -E "^[[:digit:]]+$" &>/dev/null;then
            echo "tag format is wrong..."
            exit 1
        fi
    fi

    if ls -1 ${PKG_SOURCE}/${APP_SERVICE_NAME} | grep "^${TAG_VERSION}$" &>/dev/null;then
        echo "${APP_SERVICE_NAME}: this version has been updated,can't update again..."
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
    if [ ! -d ${PKG_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION ];then
	 mkdir -p ${PKG_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION
    fi
	 mv ${TEMP_DIR}/${j} ${PKG_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION
	
	 if [ ! -d ${BACKUP_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION ];then
	     mkdir -p ${BACKUP_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION
	 fi
	
    if ! ls ${BACKUP_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION/* &>/dev/null;then
	 \cp -a -r  ${TOMCAT_DIR}/webapps/${APP_SERVICE_NAME} ${BACKUP_SOURCE}/${APP_SERVICE_NAME}/$TAG_VERSION
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
    APP_NAME=$1
    APP_LINK=$(echo ${APP_NAME} | sed -r "s@(.*.war)(.*)@\1@g")
    APP_DIR=$(echo ${APP_NAME/\.war*/})
    rm -rf $APP_LINK $APP_DIR
    ln -s ${PKG_SOURCE}/${APP_DIR}/$TAG_VERSION/$APP_NAME $APP_LINK
    LINK_SOURCE=$(ls -l $APP_LINK | awk '{print $NF}')
    ##clean expired pkg(store 8 pkg for every project)
    rm  -rf  $(ls -1 -r ${PKG_SOURCE}/${APP_DIR}/*/${APP_LINK}-* | grep -v "${LINK_SOURCE}" | sed -n "8,\$p" | sed -r "s#(.*)/(.*)#\1#g")
}


##check tomcat service
CHECK_TOMCAT_SERVICE() {
    if [ -f $CHECK_SCRIPT ];then
        echo -e "\nnow,check tomcat application url:"
        bash $CHECK_SCRIPT
    else
	echo "check script not exists..."
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
#    read -p "please input app_name: " APP_NAME

    APP_NAME="$1"

    if [ x"${APP_NAME}" = x"" ];then
        echo "you need to provide 1 parameter: [for example: list <app_name>]..."
        exit 1
    fi

    if ls -l ${TOMCAT_DIR}/webapps/${APP_NAME}.war &>/dev/null;then
        CURRENT_VER=$(ls -l ${TOMCAT_DIR}/webapps/${APP_NAME}.war | awk '{print $NF}')
	echo -e "the applicaion current version as fllows: "
        echo -e "${CURRENT_VER}\n"
    else
	echo "no such application..."
        exit 1
    fi

    if ! ls -1 ${PKG_SOURCE}/${APP_NAME}/*/${APP_NAME}.war-* &>/dev/null;then
        echo "sorry,the application no last version..."
	exit 1
    else
        LAST_VER=$(ls -1r ${PKG_SOURCE}/${APP_NAME}/*/${APP_NAME}.war-* | grep -v "$CURRENT_VER")
        echo -e "last versions are as follows: "
	echo -e "${LAST_VER}\n"
    fi        	  
}


##rollback to the specified version
ROLLBACK() {
#    read -p "please input app_name: " APP_NAME
#    read -p "please input rollback version: "  ROLLBACK_POINT

    APP_NAME="$1"
    LIST_VER $APP_NAME &>/dev/null
    ROLLBACK_POINT="$2"

    if [ x"$ROLLBACK_POINT" = x"" ];then
	echo "you need to provide 2 parameters: [for example: rollback <app_name> <rollback_point>]..."
	exit 1
    fi

    LIST_VER $APP_NAME

    if ! echo "$LAST_VER" | grep "$ROLLBACK_POINT" &>/dev/null;then
	echo "rollback point not exists..."
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
        rm -f ${TOMCAT_DIR}/webapps/${APP_NAME}.war
        ln -s $ROLLBACK_POINT ${TOMCAT_DIR}/webapps/${APP_NAME}.war
    fi   
    START_TOMCAT
}


##main
case $1 in
deploy)
    CHECK_FILE
    DEPLOY
    ;;
list)
    LIST_VER $2
    ;;
rollback)
    ROLLBACK $2 $3 
    ;;
*)
    echo "Usage: $0  {deploy | list | rollback <app_name> <rollback_point>}..."
    ;;
esac

exit 0
