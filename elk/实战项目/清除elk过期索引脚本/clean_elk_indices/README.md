说明：
该脚本用于清除elk中过期索引，按照业务线组进行匹配清除

脚本目录文件说明：
    /usr/local/weihu/clean_elk_indices  ##默认脚本家目录，可以修改SOURCE_ROOT变量覆盖默认设置
    clean_elk_index.sh  ##主脚本
    indicies.txt        ##对应业务线组elk索引列表文件（保存所有索引）
    expired_indicies_date.txt  ##过期的索引列表

脚本执行方法：
    （1）脚本需要放在es集群主节点上
    （2）执行方式：
         手动执行：cd /usr/local/weihu/clean_elk_indices && sh clean_elk_index.sh
         定时任务执行，定期进行清理，默认是清除两个月前的索引。
