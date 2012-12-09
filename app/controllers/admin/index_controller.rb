class Admin::IndexController < Admin::AdminController
  def index
    @play_models = [ [{:model => :review, :action => :new }, {:model => :review, :action => :index},
                      {:text => "Now Playing", :action => admin_reviews_path + "?show=is_playing" }],
                      [{:model => :production, :action => :new }, {:model => :production, :action => :index},
                      {:text => "Now Playing", :action => admin_productions_path + "?show=is_playing" },
                      {:text => "Will Open", :action => admin_productions_path + "?show=will_open" }],
                      "Play", "Theatre" ]
    @reviewer_models    = [ "Critic", "Publication" ]
    @participant_models = [ "Participant", "Relationship", "Relationship_Type" ]
    @user_models        = [ "Report", "User_Review",
                      [{:model => :user, :action => :new }, {:model => :user, :action => :index},
                      {:text => "Email List", :action => admin_users_email_list_path }],
                      "Email", "Role", "Access_Code" ]
    @misc_models        = [ "Post", "Quote", "Page", "Panel" ]

    @groups = [ @play_models, @reviewer_models, @participant_models, @user_models, @misc_models ]

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end