FactoryGirl.define do
  # Users

  # Prototype user factory
  factory :user, aliases: [:owner] do |_u|
    sequence :uid do |n|
      "person#{n}"
    end
    email { "#{uid}@example.com" }
    password { uid }
    new_record false
  end

  factory :archivist, parent: :user do |_u|
    uid 'archivist1'
    password 'archivist1'
  end
  factory :registered_user, parent: :user do |_u|
    uid 'registered_user'
    password 'registered_user'
  end
  factory :staff, parent: :user do |_u|
    uid 'staff1'
    password 'staff1'
    roles { ["staff"] }
  end
  factory :student, parent: :user do |_u|
    uid 'student1'
    password 'student1'
    roles { ["student"] }
  end
  factory :joe_creator, parent: :user do |_u|
    uid 'joe_creator'
    password 'joe_creator'
    roles { ["faculty"] }
  end
  factory :martia_morocco, parent: :user do |_u|
    uid 'martia_morocco'
    password 'martia_morocco'
    roles { ["faculty", "africana-faculty"] }
  end
  factory :ira_instructor, parent: :user do |_u|
    uid 'ira_instructor'
    password 'ira_instructor'
    roles { ["faculty", "africana-faculty"] }
  end
  factory :calvin_collaborator, parent: :user do |_u|
    uid 'calvin_collaborator'
    password 'calvin_collaborator'
    roles { ["student"] }
  end
  factory :sara_student, parent: :user do |_u|
    uid 'sara_student'
    password 'sara_student'
    roles { ["student", "africana-104-students"] }
  end
  factory :louis_librarian, parent: :user do |_u|
    uid 'louis_librarian'
    password 'louis_librarian'
    roles { ["library-staff", "repository-admin"] }
  end
  factory :carol_curator, parent: :user do |_u|
    uid 'carol_curator'
    password 'carol_curator'
    roles { ["library-staff", "repository-admin"] }
  end
  factory :alice_admin, parent: :user do |_u|
    uid 'alice_admin'
    password 'alice_admin'
    roles { ["repository-admin"] }
  end

  #
  # Repository Objects
  #

  factory :asset, class: ModsAsset do |o|
  end

  factory :admin_policy, class: Hydra::AdminPolicy do |o|
  end

  factory :default_access_asset, parent: :asset do |_a|
    permissions_attributes [{ name: "joe_creator", access: "edit", type: "person" }]
  end

  factory :dept_access_asset, parent: :asset do |_a|
    permissions_attributes [{ name: "africana-faculty", access: "read", type: "group" }, { name: "joe_creator", access: "edit", type: "person" }]
  end

  factory :group_edit_asset, parent: :asset do |_a|
    permissions_attributes [{ name: "africana-faculty", access: "edit", type: "group" }, { name: "calvin_collaborator", access: "edit", type: "person" }]
  end

  factory :org_read_access_asset, parent: :asset do |_a|
    permissions_attributes [{ name: "registered", access: "read", type: "group" }, { name: "joe_creator", access: "edit", type: "person" }, { name: "calvin_collaborator", access: "edit", type: "person" }]
  end

  factory :open_access_asset, parent: :asset do |_a|
    permissions_attributes [{ name: "public", access: "read", type: "group" }, { name: "joe_creator", access: "edit", type: "person" }, { name: "calvin_collaborator", access: "edit", type: "person" }]
  end
end
