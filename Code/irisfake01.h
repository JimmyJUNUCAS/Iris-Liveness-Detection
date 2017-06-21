// TestOpenCV.cpp : 定义控制台应用程序的入口点。
#include <opencv2/opencv.hpp>
#include <cxcore.h> 
#include  <highgui.h>
#include  <cv.h>   

#include <iostream>  
#include <fstream> 
#include <iterator>  
#include <vector> 
using namespace std;


//提取LBP特征

void LBP(IplImage *Gray_face, IplImage *LBP_face)
{
	int tmp[8] = { 0 };
	CvScalar s;
	uchar *data = (uchar*)Gray_face->imageData;
	int step = Gray_face->widthStep;

	for (int i = 1; i < Gray_face->height - 1; i++)
	{
		for (int j = 1; j < Gray_face->width - 1; j++)
		{
			if (data[(i - 1)*step + j - 1]>data[i*step + j])
				tmp[0] = 1;
			else
				tmp[0] = 0;
			if (data[i*step + (j - 1)]>data[i*step + j])
				tmp[1] = 1;
			else
				tmp[1] = 0;
			if (data[(i + 1)*step + (j - 1)] > data[i*step + j])
				tmp[2] = 1;
			else
				tmp[2] = 0;
			if (data[(i + 1)*step + j] > data[i*step + j])
				tmp[3] = 1;
			else
				tmp[3] = 0;
			if (data[(i + 1)*step + (j + 1)] > data[i*step + j])
				tmp[4] = 1;
			else
				tmp[4] = 0;
			if (data[i*step + (j + 1)] > data[i*step + j])
				tmp[5] = 1;
			else
				tmp[5] = 0;
			if (data[(i - 1)*step + (j + 1)] > data[i*step + j])
				tmp[6] = 1;
			else
				tmp[6] = 0;
			if (data[(i - 1)*step + j] > data[i*step + j])
				tmp[7] = 1;
			else
				tmp[7] = 0;
			//计算LBP编码  
			s.val[0] = (tmp[0] * 1 + tmp[1] * 2 + tmp[2] * 4 + tmp[3] * 8 + tmp[4] * 16 + tmp[5] * 32 + tmp[6] * 64 + tmp[7] * 128);

			cvSet2D(LBP_face, i, j, s);//写入LBP图像  
		}
	}
	// 边缘
	for (int i = 0; i < Gray_face->height; i++)
	{
		s.val[0] = LBP_face->imageData[i*step + 1];
		cvSet2D(LBP_face, i, 0, s);

		s.val[0] = LBP_face->imageData[i*step + Gray_face->width - 2];
		cvSet2D(LBP_face, i, Gray_face->width - 1, s);
	}
	for (int j = 0; j < Gray_face->width; j++)
	{
		s.val[0] = LBP_face->imageData[1*step + j];
		cvSet2D(LBP_face, 0, j, s);

		s.val[0] = LBP_face->imageData[(Gray_face->height - 2)*step + j];
		cvSet2D(LBP_face, Gray_face->height - 1,j, s);
	}
}

void hist_lbp(IplImage *LBP_face, cv::Mat& histData)
{

	int hist_size = 256;
	CvHistogram* gray_hist = cvCreateHist(1, &hist_size, CV_HIST_ARRAY);
	cvCalcHist(&LBP_face, gray_hist, 0, 0);

	float fMaxHistValue = 0;
	cvGetMinMaxHistValue(gray_hist, NULL, &fMaxHistValue, NULL, NULL);
	int nImageHeight = 256;
	float* data = histData.ptr<float>();
	for (int i = 0; i < hist_size; i++)
	{
		data[i] = (float)(cvGetReal1D((gray_hist)->bins, i)*1.0) / (LBP_face->height * LBP_face->width);
	}
	
}


//加载文件R 
int LoadData(string fileName, cv::Mat &matData, int matRows = 0, int matCols = 0, int matChns = 0)
{
	int retVal = 0;

	// 打开文件  
	ifstream inFile(fileName.c_str(), ios_base::in);
	if (!inFile.is_open())
	{
		cout << "读取文件失败" << endl;
		retVal = -1;
		return (retVal);
	}

	// 载入数据  
	istream_iterator<float> begin(inFile);    //按 float 格式取文件数据流的起始指针  
	istream_iterator<float> end;              //取文件流的终止位置  
	vector<float> inData(begin, end);         //将文件数据保存至 std::vector 中  
	cv::Mat tmpMat = cv::Mat(inData);         //将数据由 std::vector 转换为 cv::Mat  
    // 检查设定的矩阵尺寸和通道数  
	size_t dataLength = inData.size();
	//1.通道数  
	if (matChns == 0)
	{
		matChns = 1;
	}
	//2.行列数  
	if (matRows != 0 && matCols == 0)
	{
		matCols = dataLength / matChns / matRows;
	}
	else if (matCols != 0 && matRows == 0)
	{
		matRows = dataLength / matChns / matCols;
	}
	else if (matCols == 0 && matRows == 0)
	{
		matRows = dataLength / matChns;
		matCols = 1;
	}
	//3.数据总长度  
	if (dataLength != (matRows * matCols * matChns))
	{
		cout << "读入的数据长度 不满足 设定的矩阵尺寸与通道数要求，将按默认方式输出矩阵！" << endl;
		retVal = 1;
		matChns = 1;
		matRows = dataLength;
	}

	// 将文件数据保存至输出矩阵 
	
	matData = tmpMat.reshape(matChns, matRows).clone();

	return (retVal);
}


//判断是否小于阈值

bool recError(cv::Mat& X, cv::Mat& R, float ThrTest)
{
	// Re(reSet) = sum((R(ii).val*X(:,reSet)).^2);
	float* dataR = R.ptr<float>();
	float* dataX = X.ptr<float>();
	
	int whatL = 0;
	for (int r = 0; r < R.rows*R.cols; r++)
	{
		float sumN = 0;
		for (int x = 0; x < X.rows; ++x)
		{
			sumN += pow(dataR[r] * dataX[x], 2);
		}
		
		if (sumN <= ThrTest)
		{
			cout << whatL << ":  " << sumN << endl;
			return true;
		}
		whatL++;
	}

	return false;
}

int main()
{
	// 对图像执行LBP
	IplImage* face = cvLoadImage("F://cat.jpg");//图片路径
	IplImage* Gray_face = cvCreateImage(cvGetSize(face), face->depth, 1);//先分配图像空间  
	cvCvtColor(face, Gray_face, CV_BGR2GRAY);//把载入图像转换为灰度图
	IplImage *LBP_face = cvCreateImage(cvGetSize(Gray_face), Gray_face->depth, 1);
	LBP(Gray_face, LBP_face);
	cvSaveImage("F://lbp.jpg", LBP_face);

	// 对LBP结果灰度统计获得X
	cv::Mat histData = cv::Mat::ones(256, 1, CV_32F);
	hist_lbp(LBP_face, histData);
	
	// 读入R
	cv::Mat R = cv::Mat::ones(256, 256, CV_32F);
	
	LoadData("F://R.txt",R);
	R = R.reshape(0,256);
	
	// 判断
	bool haveEye = recError(histData, R, 0.001);
    cout << haveEye << endl;

	char t;
	cin >> t;
	//waitKey();
	return 0;
}

