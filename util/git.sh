#!/bin/bash -x

git_host="https://github.com"
tmp_log="tmp_repos.log"


function gitclone()
{
  username=$1
  if [ ! -d $username ];then
  	mkdir -p $username
  fi
  cd $username
  if [ -f $tmp_log ];then
  	rm $tmp_log
  fi
  
  # 查找分页数，发现两种，一种找到总仓库数，再得到页数，另一种是直接找到最大的页码，这里选择第二种
  curl $git_host/$username?tab=repositories | grep page= | grep -oP '(?<=href=").*?(?=">)'|sort > $tmp_log

  pageNum=$(grep 'page=' $tmp_log | tail -n 1 | grep -oP '[0-9]?')
  echo $pageNum
  rm $tmp_log
  #是否分页
  if [ ! $pageNum ];then
    curl $git_host/$username?tab=repositories | grep codeRepository | grep -oP '(?<=href=").*?(?=")' > $tmp_log
  else
    for ((i=1;i<=$pageNum;i++))
  	do
  	   curl "$git_host/$username?tab=repositories&page=$i" | grep codeRepository | grep -oP '(?<=href=").*?(?=")' >> $tmp_log
  	done
  fi
  
  cat $tmp_log | while read line
	do
        # 找到仓库的名字
        name=$(basename $line)
        # 方式一：下载zip包
        wget https://codeload.github.com$line/zip/master -O $name.zip
        # 方式二：git clone 
        # git clone https://github.com$line.git
	done
}

gitclone $1

