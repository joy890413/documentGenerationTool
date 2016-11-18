#!/bin/sh

#进入之后选择 输入类型参数(1,2,3)区别平台类型,需要英文还是中文(en,cn),和输入文件路径文件夹地址 -> 生成出文档

#内部步骤:1.check代码是否有没有翻译的内容  ->得到结果是否下一步 y/n
#2.delete代码,根据参数选择delete中文或者英文,生成达到文档要求的格式的文件(根据平台参数选择,ios和安卓会有/*!和/**的区别,不过貌似都用/**也可以)
#3.根据平台的参数选择,用不同的文档生成工具生成文档(appDoc && javaDoc)
#4.目前需要判断出
targetEngiOSName='EnglishiOSDes'
targetChiiOSName='ChineseiOSDes'

rm -rf help


echo "start build the description."

echo "Please input the platform: 1. iOS 2. Android"

read paflag

echo "Please input the description for which language:1.Chinese 2.English"

read laFlag

echo "Please input the code file path:"

read Foldpath

if [ $laFlag = "1" ]; then
	#表示是web,但是不知道是中文还是英文.
	#如果是1,表示是中文,需要查找是否已经修改完成
	echo "First Check the description"	
elif [ $laFlag = "2" ]; then
	#表示是英文	
	echo "First generate the description".
else
	echo "Please input the right choose."
fi	

#检测文件夹是否存在(有错误,暂时不处理了)
if [ ! -d $Foldpath ]; then
	echo "the path is right"
else
	echo "path is not right"
fi
if [ $laFlag = "1" ]; then
	sh ./checkFileV1.1.sh $Foldpath
	echo "we check all the translation and input the description without the Chinese into the Checkresult.txt We will continue to generate the description?  1. continue 2. quit"
	read conFlag
	if [ $conFlag = "1" ]; then
		#继续生成	中文的注释,需要讲英文的删除
		if [ $paflag = "1" ]; then
			#表示是iOS的版本,同时是中文.
			echo "ios chinese"
			sh ./deleteCh.sh $Foldpath
			path=$(pwd)			
			sh appledoc2html.sh -p $path -t $targetChiiOSName
		else
			#表示是Android的版本,
			echo "Android chinese"
			mkdir AndroidChiDes
			cp javadocCh.sh AndroidDes/javadocCh.sh
			cp -R $Foldpath AndroidChiDes/$Foldpath
			cd AndroidChiDes
			sh ./javadocCh.sh $Foldpath
		fi
	fi
elif [ $laFlag = "2" ]; then
	#表示是英文	
	echo "generate the description for English"
	#echo "First generate the description".
	#cat result.txt
	if [ $paflag = "1" ]; then
		#表示是iOS的版本,同时是英文
		path=$(pwd)			
		sh appledoc2html.sh -p $path -t $targetEngiOSName
	else
		#表示是Android的版本,
		echo "Android English"
		mkdir AndroidDes
		#cp javadocEn.sh AndroidDes/javadocEn.sh
		cp -R $Foldpath AndroidDes/$Foldpath
		#
		cd AndroidDes
		sh ./javadocEn.sh $Foldpath
	fi
else
	echo "Please input the right choose."
fi


echo "not "
echo 'Finish!'