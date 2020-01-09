require 'rails_helper'
require "refile/file_double"

RSpec.describe User, type: :model do

  describe '実際に保存してみる' do
  	context "保存できる場合" do
  	  it "画像無しの場合"
  	    expect(FactoryBot.create(:user)).to be_valid
  	  end
  	  it "画像がある場合"
  	    expect(FactoryBot.create(:user, :create_with_profile_image)).to be_valid
  	  end
  	end

    context "保存できない場合" do
  	  it "nameが空の場合"
  	    expect(FactoryBot.build(:user, :no_name)).to_not be_valid
      end
      it "emailが空の場合"
  	    expect(FactoryBot.build(:user, :no_email)).to_not be_valid
  	  end
      it "nameが30文字以上の場合"
        expect(FactoryBot.build(:user, :too_long_name)).to_not be_valid
      end
      it "introductionが200文字以上の場合"
        expect(FactoryBot.build(:user, :too_long_introduction)).to_not be_valid
      end
    end
  end
end