require 'spec_helper'
 
describe ThemeAsset do
  
  describe 'attaching a file' do
    
    before(:each) do
      ThemeAsset.any_instance.stubs(:site_id).returns('test')
      @asset = Factory.build(:theme_asset)
    end
    
    describe 'file is a picture' do
    
      it 'should process picture' do
        @asset.source = FixturedAsset.open('5k.png')
        @asset.source.file.content_type.should_not be_nil
        @asset.image?.should be_true
      end
      
      it 'should get width and height from the image' do
        @asset.source = FixturedAsset.open('5k.png')
        @asset.width.should == 32
        @asset.height.should == 32
      end
      
      it 'should have a slug' do
        @asset.source = FixturedAsset.open('5k.png')
        @asset.save
        @asset.slug.should == '5k'
      end
      
    end
    
    describe 'file is not allowed' do
      
      it 'should not be valid' do
        @asset.source = FixturedAsset.open('wrong.txt')
        @asset.valid?.should be_false
        @asset.errors[:source].should_not be_blank
      end
      
    end
  
    it 'should process stylesheet' do
      @asset.source = FixturedAsset.open('main.css')
      @asset.source.file.content_type.should_not be_nil
      @asset.stylesheet?.should be_true
    end
    
    it 'should process javascript' do
      @asset.source = FixturedAsset.open('application.js')
      @asset.source.file.content_type.should_not be_nil
      @asset.javascript?.should be_true
    end
    
    it 'should get size' do
      @asset.source = FixturedAsset.open('main.css')
      @asset.size.should == 25
    end
  
  end
  
  describe 'creating from plain text' do
    
    before(:each) do
      ThemeAsset.any_instance.stubs(:site_id).returns('test')
      @asset = Factory.build(:theme_asset)
      @asset.performing_plain_text = true
      @asset.slug = 'a file'
      @asset.plain_text = "Lorem ipsum"
    end
      
    it 'should handle stylesheet' do
      @asset.content_type = 'stylesheet'
      @asset.valid?.should be_true
      @asset.stylesheet?.should be_true
      @asset.source.should_not be_nil
    end  
    
    it 'should handle javascript' do
      @asset.content_type = 'javascript'
      @asset.valid?.should be_true
      @asset.javascript?.should be_true
      @asset.source.should_not be_nil
    end
    
  end
  
end