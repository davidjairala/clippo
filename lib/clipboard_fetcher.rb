require 'clipboard'

class ClipboardFetcher

  class Result < Struct.new(:filename, :data)
  end

  def set(val)
    Clipboard.copy(val)
  end

  def get
    data   = nil
    data ||= clipboard_image
    data ||= clipboard_text
  end

  private

    # paste text from clipboard
    def clipboard_text
      txt_filename = create_filename('txt')
      data = Clipboard.paste
      Result.new(txt_filename, data)
    end

    # paste image to tmp folder
    # returns file data
    def clipboard_image
      img_filename = create_filename('png')
      img_file = File.join(tmp_folder, img_filename)

      # try to paste image
      %x[pngpaste #{img_file} > /dev/null 2>&1]

      # if something went wrong, return nil
      return nil if $?.exitstatus.to_i != 0

      # success, lets return file data
      data = File.open(img_file, 'rb') do |f|
        f.read
      end

      File.delete(img_file)

      Result.new(img_filename, data)
    end

    def create_filename(ext)
      tmp_name = "#{Time.now.to_i}__#{rand(999999999)}"
      img_filename = "#{tmp_name}.#{ext}"
    end

    def tmp_folder
      File.join(Syncer.root, 'tmp_files')
    end

end
