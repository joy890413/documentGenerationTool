#!/bin/sh

#检测当前所有的文件，
#查询所有的文件,将其修改为UTF-8-MAC 格式的就可以.然后删除修改之后的?文件.
#讲所有的/**   */ 全部删除掉.
#讲/* .cn修改成/** 这个好改.
#最后生成就可以了.

#实际上我们应该完成的是






#FileInfo=`iconv -c -f UTF-8 -t UTF-8-MAC IContainerItemProvider\(1\).java`
#rm IContainerItemProvider\(1\).java
#echo  $FileInfo > IContainerItemProvider\(1\).java

#sed -i '' 's/\/\*\* \*\//' a.java

#sed -i '' '/\/\* .cn/,/\*\//d' a.java


#javadoc -locale en_US IContainerItemProvider.java -encoding GBK -charset UTF-8


function DeleteChDetail()
{
	local foldFileList=`ls $1`
for file in $foldFileList
do
	if [ -f $file ]; then
		if [ $file != 'javadocEn.sh' ]; then
			if  [ "${file##*.}" = "java" ]; then
				sed -i '' '/\/\* .cn/,/\*\//d' $file
				javadoc -locale en_US $file
			fi
		fi
	else
		local InnerfilePath=$1'/'$file
		DeleteChDetail $InnerfilePath
	fi
	
done
}

DeleteChDetail $1

echo "Finish"