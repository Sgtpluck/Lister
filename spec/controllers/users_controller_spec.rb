require 'spec_helper'
describe UsersController do

  describe "GET 'new'" do
    it "is successful" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST 'create'" do
    context "with valid attributes" do
      let(:valid_attributes) { {username: "bookis", email: "b@c.com", password: "gogo1234", password_confirmation: "gogo1234"} }
      before do 
        session[:user_id] = nil
      end
      
      it "is a redirect" do
        post :create, user: valid_attributes
        expect(response.status).to eq 302 # This is a redirect
      end
    
      it "changes user count by 1" do
        expect { post :create, user: valid_attributes }.to change(User, :count).by(1)
      end
    
      it "sets a flash message" do
        post :create, user: valid_attributes
        expect(flash[:notice]).to_not be_blank
      end

      it 'sets the session[:user_id]' do
        post :create, user: valid_attributes
        assigns(:user)
        expect(session[:user_id]).to_not be_nil
    end
  end
  
    context "with invalid attributes" do
      it "renders the new template" do
        post :create, user: {username: "b"}
        expect(response).to render_template :new
      end
    
      it "does not create a user" do
        expect { post :create, user: {username: "b"} }.to change(User, :count).by(0)
      end
    end
  end

  describe "GET 'show'" do

    context 'user is logged in' do
    let(:user) { create(:user) }
    before do 
      session[:user_id] = user.id
    end
    render_views
      
      it "is successful" do
        get :show, id: user.id
        expect(response).to be_successful
      end

      it "has an array of the users' lists" do
        list = create(:list)
        list2 = create(:list2)
        get :show, id: user.id
        expect(assigns(:lists)).to match_array([list])
      end

      it "does not have other users' lists in @lists" do
        list = create(:list)
        list2 = create(:list2)
        get :show, id: user.id
        expect(assigns(:lists)).to_not match_array([list,list2])
      end

      it "loads all the users' lists in the view" do
        list = create(:list)
        list2 = create(:list2)
        get :show, id: user.id
        expect(response.body).to include(list.title)
        expect(response.body).to include(list.description)
      end
    end

    context 'no user is logged in' do
      before do 
        session[:user_id] = nil
      end

      it 'redirects to the root page' do
        get :show, id: 1
        expect(response).to redirect_to root_path
      end
    end
  end
end
