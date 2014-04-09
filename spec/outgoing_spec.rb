describe Telesms::Outgoing do
  let(:klass) { Telesms::Outgoing }
  let(:from) { Faker::Internet.email }
  let(:to) { Faker::Base.numerify('##########') }
  let(:provider) { 'AT&T' }
  let(:message) { Faker::Lorem.sentence }
  let(:outgoing_message) { klass.new(from, to, provider, message) }

  describe "class methods" do
    describe ".deliver" do
      subject { klass }

      before do
        klass.stub new: outgoing_message
        outgoing_message.stub(:deliver)
        klass.deliver(from, to, provider, message)
      end

      it { should have_received(:new).with(from, to, provider, message) }
      it { expect(outgoing_message).to have_received(:deliver) }
    end
  end

  describe "initialize" do
    subject { klass.new(from, to, provider, message) }
    it { expect(subject.from).not_to be_blank }
    it { expect(subject.to).not_to be_blank }
    it { expect(subject.provider).not_to be_blank }
    it { expect(subject.message).not_to be_blank }
  end

  describe "deliver" do
    subject { outgoing_message.deliver }
    it { should have_sent_email }
    it { should have_sent_email.from(from) }
    it { should have_sent_email.to(outgoing_message.formatted_to) }
    it { should have_sent_email.with_body(message) }
  end

  describe "formatted_to" do
    subject { outgoing_message.formatted_to }
    it { should match /#{to}\@[a-zA-Z0-9\.\-]+/ }
  end

  describe "sanitized_message" do
    subject { outgoing_message.sanitized_message }
    it { should eq outgoing_message.message }
  end
end