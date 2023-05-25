# frozen_string_literal: true

describe 'rake import:users' do
  it 'creates users during import' do
    new_env = ENV.to_hash.merge('filename' => 'spec/fixtures/users.xml')
    stub_const('ENV', new_env)
    expect { Rake::Task['import:users'].invoke }
      .to change(User, :count).by(2)
  end
end
