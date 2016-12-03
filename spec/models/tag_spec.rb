require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'should be valid' do
    expect(build(:tag)).to be_valid
  end
end
