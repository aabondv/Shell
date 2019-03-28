#!/bin/bash

# author: aabond
# create-date: 2019-03-28
# todo: 实现进度条 

# 实现进度条
# @param1 当前值
# @param2 总值
function process() {
	local b=''
	local cur=$1
	local total=$2
	local i=$((cur*100/total))
	for((k=0;k<$i/2;k++))
	do
		b=-$b
	done
	printf "\033[32mprogress:[%-50s]%d%%\033[0m\r" $b $i

}
# 测试
function test() {

	for((i=0;i<=10000;i++))
	do
		echo $i > .tmp.log
	done
}
# 主要
function main() {
	test &
	flag=1 #标志进度条是否到达100%
	while [ $flag -eq 1 ]
	do
		cur=`tail -1 .tmp.log`
		[ -n "$cur" ] && process $cur 10000
		[ "$cur" == "10000" ] && { flag=0;printf "\n";}
	done
	[ -e .tmp.log ] && rm .tmp.log
}
main








