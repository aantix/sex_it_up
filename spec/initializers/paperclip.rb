module Paperclip
  module Interpolations
    # Returns the Rails.root constant.
    def rails_root attachment, style_name
      ROOT_DIR
    end

    # Returns the Rails.env constant.
    def rails_env attachment, style_name
      'test'
    end
  end
end
