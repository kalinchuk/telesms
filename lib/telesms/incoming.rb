module Telesms
  class Incoming
    attr_reader :mail

    def self.receive(params)
      self.new(params).parse
    end

    def initialize(params)
      @mail = Mail.new(params)
    end

    def parse
      clean_body!

      {
        from: @mail.from.first,
        to: @mail.to,
        body: @mail.body[0,160]
      }
    end

    def clean_body!
      @mail.body = @mail.parts.last.body.decoded if @mail.multipart?
      @mail.body ||= @mail.body.to_s
      @mail.body = @mail.body[0, @mail.body.index(original_message_regex) || @mail.body.length].to_s
      @mail.body = @mail.body.split(/\n\s*\n/m, 2)[1] || @mail.body if @mail.body.match(/\n/)
      @mail.body = @mail.body.to_s.gsub(/(.*--__CONTENT_.*)|\n/, '').strip
    end

    def original_message_regex
      /(-----Original Message-----)/
    end
  end
end

# Telesms::Incoming.receive(params[:mail])
# Telesms::Incoming.receive({:to => '', :form => ''})