require 'yaml'
require 'aws-sdk'

require 'active_support/core_ext/hash/keys'
require 'active_support'

class Uploader

  def initialize(result)
    @result = result
    Aws.config.update(s3_config.except(:bucket))
  end

  # uloads a file to s3 and returns its public URL
  def upload
    resp = upload_file
    make_file_public if resp.successful?
    file.public_url
  end

  private

    def make_file_public
      file.acl.put(acl: 'public-read')
    end

    def file
      @file ||= bucket.object(filename)
    end

    def upload_file
      s3 = Aws::S3::Client.new(base_config)
      s3.put_object({
        body: @result.data,
        bucket: bucket_name,
        key: filename
      })
    end

    def bucket
      @bucket ||= begin
        s3 = Aws::S3::Resource.new(base_config)
        b = s3.bucket(bucket_name)

        unless b
          b = s3.create_bucket(bucket: bucket_name)
        end

        unless b.exists?
          b.create
        end

        b
      end
    end

    def filename
      "#{dir}/#{@result.filename}"
    end

    def dir
      @dir ||= Time.now.strftime("%Y-%m-%d")
    end

    def bucket_name
      s3_config[:bucket]
    end

    def region_config
      {region: s3_config[:region]}
    end

    def base_config
      s3_config.except(:bucket)
    end

    def s3_config
      @s3_config ||= YAML.load(File.open(File.join(Syncer.root, 'config', 'config.yml')).read)['s3'].symbolize_keys
    end

end
