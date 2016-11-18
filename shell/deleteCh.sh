#!/bin/sh

#检测当前所有的文件，
#主要是实文件夹的查找，还有所有的文件的读取之后重新写入的问题。
#首先遍历文件夹

#实际上我们应该完成的是


foldPath=$1
forFileList=$(ls)
#生成文本名称
infoFilePath='Deleteresult.txt'
midFilePath='Midtext.txt'
#读取其中没有注释的参数
function GetWrongNote()
{
	local wrongInfo
	local inputInfo
	local lineNum
	local readLineNum
	local startNum
	local endMNum
	local endNum
	local arrayStartLine
	local arrayEndLine
	local deleteNum
	deleteNum=0
	lineNum=1
while read myline
do
	readLineNum=$lineNum
	let "lineNum+=1"
	#18:/*! .en
	if [[ $myline =~ "en" ]]; then
		echo 'wait'
	else
		#错误的就是对的。
		wrongInfo=$(sed -n $lineNum'p' $1 )
		if [[ $wrongInfo =~ "en" ]]; then
			startNum=$(echo $myline | cut -d ':' -f 1)
			endMNum=$(echo $wrongInfo | cut -d ':' -f 1)
			endNum=$((endMNum-1))
			arrayStartLine[$deleteNum]=$startNum
			arrayEndLine[$deleteNum]=$endNum
			let "deleteNum+=1"
			#sed -i -e $startNum,$endNum'd' $2
		else
			#inputInfo=$(awk )
			echo '123'
			#echo $myline | cut -d ':' -f 1 >>  $infoFilePath
		fi
	fi
done < $1

#delete 所有的数据，但是要从大到小
for((i=$deleteNum;i>=0;i--)); 
do
	#echo ${arrayStartLine[$i]}
	sed -i -e ${arrayStartLine[$i]},${arrayEndLine[$i]}'d' $2
done

}

function ModifyFile()
{
	local num=0
	num=$(grep -E -n -c '/\*' $1)
	#echo 'ModifyAndroidFile'$num
	if [ $num -gt 0 ]; then
		echo $1 >>  $infoFilePath
		grep -E -n '/\*' $1 > $midFilePath
		GetWrongNote $midFilePath $1
	fi
}


function GetFile()
{
	local foldFileList=`ls $1`
if [ $# != 1 ] ; then
		echo "Please input the path of the file"
		exit
fi
for file in $foldFileList
do
	if [ -f $file ]; then
		if [ "${file##*.}" != "sh" ]; then
			if  [ "${file##*.}" = "java" ]; then
				#Android文件中的与原有的文件不一致。
				#info=$file
				#echo $info >>  $infoFilePath
				#echo 'Java'$info
				ModifyFile $file
			sed -i -e 's/ .en/    /g' $file
			else
				if  [ "${file##*.}" = "h" ]; then
					#echo 'IOS'$file  
					ModifyFile $file
			sed -i -e 's/ .en/    /g' $file
				fi	
			fi
		fi
	else
		#如果不是，就会是基本的文件
		local InnerfilePath=$1'/'$file
		GetFile $InnerfilePath
	fi
done

}

#delete all things last create
rm -f Midtext.txt
rm -f info.txt
GetFile ${foldPath}
rm -f Midtext.txt

echo 'Finish delete!'