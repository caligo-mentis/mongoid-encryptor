# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "Symmetric encryption on embedded document" do
  let(:person) do
    Person.new(:first_name => 'John',
               :last_name => 'Smith',
               :credential => ShaCredential.new(:email => 'john@example.com', :password => 'secret'),
               :credit_cards => [CreditCard.new(:number => '0000111122224444')])
  end

  context "Has valid attributes" do
    context "Before save" do
      subject { person.credit_cards }
      it { should have(1).card }
      describe "person.credit_cards.first" do
        subject { person.credit_cards.first }
        its(:number) { should_not be_encrypted }
        its(:number) { should eq('0000111122224444') }
        its(:number) { should_not eq("0pOZeQMtxuPsAPaoR3fkjMEUIoAuSbFO\n") }
        it { should be_valid }
      end
    end

    context "after save" do
      before { person.save!; puts person.credit_cards.first.number }
      subject { person.credit_cards }
      describe "person.credit_cards.first" do
        subject { person.credit_cards.first }
        its(:number) { should be_encrypted }
        its(:number) { should eq("0pOZeQMtxuPsAPaoR3fkjMEUIoAuSbFO\n") }
        its(:number) { should eq('0000111122224444') }
      end
    end
  end

  it "doesn't encrypt value of field after validation" do
    person.credit_cards.first.valid?
    person.should be_valid
  end

end
