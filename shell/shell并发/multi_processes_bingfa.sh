#!/bin/bash
PIPE_FILE=/root/shell_bingfa/xx.fifo
mkfifo $PIPE_FILE	#创建一个管道文件
exec 1000<>$PIPE_FILE    #这里是将管道文件与文件操作符关联在一起，这样可以使用文件操作符1000访问它，<>表示读操作和写操作；
rm -f $PIPE_FILE	#清空管道文件中的内容

for((i=1;i<5;i++));do    #设置进程并发数【控制进程并发数，因为管道文件的读取是按照行为单位的；这里并发设置为4，所以需要往管道文件中写入4个空行】
    echo >&1000
done

START_TIME=$(date +%s)

for i in $(seq 1 20);do
#read -u1000 的作用是：读取一次管道中的一行，在这儿就是读取一个空行；减少操作附中的一个空行之后，执行一次任务（当然是放到后台执行）;需要注意的是，这个任务在后台执行结束以后会向文件操作符中写入一个空行，这就是重点所在，如果我们不在某种情况某种时刻向操作符中写入空行，那么结果就是：在后台放入10个任务之后，由于操作符中没有可读取的空行，导致  read -u1000 这儿 始终停顿。
    read -u1000
    {
    	echo "SUCCESS"
    	sleep 1
	echo >&1000	
    }&
done

wait			#等待所有后台进程执行完毕后在执行后面的代码
END_TIME=$(date +%s)

echo "exec_time: $((${END_TIME}-${START_TIME}))s"

##close file_operator    #当所有代码执行完毕，需要关闭文件操作符，读和写的关闭需要分开写
exec 1000>&-
exec 1000<&-
