############################     S3 BUCKET   ######################################################

resource "aws_s3_bucket" "MeraBuckethai" {
  bucket = "merabucket11"
  tags = {
    Name        = "MyBucket11"
  
}

############################   UPLOAD OBJECT    ################################################# 
resource "aws_s3_bucket_object" "object" {

  bucket = aws_s3_bucket.MeraBuckethai.id

  key    = "profile"

  acl    = "private" 

  source = "/home/seasia/Documents/myfile/yourfile.txt"

  etag = md5("/home/seasia/Documents/myfile/yourfile.txt")

}
 
