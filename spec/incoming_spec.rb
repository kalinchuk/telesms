describe Telesms::Incoming do
  let(:klass) { Telesms::Incoming }
  let(:params) {{
    from:   ['555555555@pacbellpcs.net'],
    to:     ['444444444@example.com'],
    body:   Faker::Lorem.sentence
  }}
  let(:incoming_message) { klass.new(params) }

  describe "class methods" do
    describe ".receive" do
      subject { klass }

      before do
        klass.stub new: incoming_message
        incoming_message.stub(:parse)
        klass.receive(params)
      end

      it { should have_received(:new).with(params) }
      it { expect(incoming_message).to have_received(:parse) }
    end
  end

  describe "initialize" do
    before do
      Mail.stub(:new).and_call_original
      incoming_message
    end

    it { expect(incoming_message.mail).to be_a Mail::Message }
    it { expect(Mail).to have_received(:new).with(params) }
  end

  describe "parse" do
    subject { incoming_message.parse }

    before do
      incoming_message.stub(:clean_body!).and_call_original
      subject
    end

    it { expect(incoming_message).to have_received(:clean_body!) }
    it { should include({ from: incoming_message.from }) }
    it { should include({ to: incoming_message.to }) }
    it { should include({ body: incoming_message.body }) }
    it { should include({ provider: incoming_message.provider }) }
  end

  describe "to" do
    subject { incoming_message.to }
    it { should eq params[:to][0] }
  end

  describe "from" do
    subject { incoming_message.from }
    it { should eq '555555555' }
  end

  describe "body" do
    subject { incoming_message.body }
    it { should eq params[:body] }
  end

  describe "gateway_host" do
    subject { incoming_message.gateway_host }

    context "when email is valid" do
      it { should eq 'pacbellpcs.net' }
    end

    context "when email is invalid" do
      before { params[:from] = nil }
      it { should be_nil }
    end
  end

  describe "provider" do
    subject { incoming_message.provider }

    context "with a matching sms gateway" do
      it { should eq 'Pacific Bell' }
    end

    context "with a matching mms gateway" do
      before { params[:from] = '555555555@mtn.com.gh' }
      it { should eq 'MTN Ghana' }
    end

    context "with no matching gateways" do
      before { params[:from] = 'fake@fake.com' }
      it { should be_nil }
    end
  end

  describe "clean_body!" do
    subject do
      incoming_message.clean_body!
      incoming_message.body
    end

    context "with a clean body" do
      it { should eq params[:body] }
    end

    context "with an original message" do
      before { params[:body] = "Test -----Original Message----- message" }
      it { should eq 'Test' }
    end

    context "with multiple lines" do
      before { params[:body] = "Test\n \n message" }
      it { should eq 'message' }
    end

    context "with a newline" do
      before { params[:body] = "Test \n message" }
      it { should eq 'Test  message' }
    end
  end

  describe "original_message_regex" do
    subject { incoming_message.original_message_regex }
    it { should eq /(-----Original Message-----)/ }
  end
end