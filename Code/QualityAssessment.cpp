double QualityAssessment(IplImage *src)
{
	int imag_h = src->height;
	int imag_w = src->width;

	//cout<<imag_h<<endl;
	//cout<<imag_w<<endl;

	double BrennerScores = 0;
	//for( int i = imag_h/4; i < 3*imag_h/4; i++ )
	//{
	//	for( int j = imag_w/4; j < 3*imag_w/4; j++ )
	//	{
	for( int i = imag_h/10; i < imag_h/3; i++ )
	{
		for( int j = 1; j < imag_w; j++ )
		{
			//BrennerScores = BrennerScores + pow((cvGet2D(src,i,j).val[0] - cvGet2D(src,i - 1,j).val[0]),2);
			BrennerScores = BrennerScores + pow((cvGet2D(src,i,j).val[0] - cvGet2D(src,i,j - 1).val[0]),2);
			//对于虹膜，只进行水平分辨率评价
		}
	}
	return BrennerScores/(imag_h*imag_w/30);
}
