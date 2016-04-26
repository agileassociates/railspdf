class UploadsController < ApplicationController
def new
end

def create
    # Make an object in your bucket for your upload
    s3 = Aws::S3::Resource.new(region:'us-west-1')
    obj = s3.bucket('railspdf').object(params[:file].original_filename)

    #  FIRST, Put the uploaded file in a variable
    uploaded_file = params[:file]

    # SECOND, get the path of the file
    file_name = uploaded_file.tempfile.to_path.to_s


    # THIRD, Upload the file using the file path
    obj.upload_file(file_name)


    # Create an object for the upload
    @upload = Upload.new(
        url: obj.public_url,
        name: obj.key
    )

    # Save the upload
    if @upload.save
      redirect_to uploads_path, success: 'File successfully uploaded'
    else
      flash.now[:notice] = 'There was an error'
      render :new
    end
end

def index
  @uploads = Upload.all
end

end