require_relative  'spec_helper'
require_relative  '../dependency'

describe User do
  let(:user) do
    User.new(name: 'Amidasd',
             difficulty: 'easy',
             total_count_attempt: 15,
             count_attempt: 2,
             total_count_hints: 2,
             count_hint: 0)
  end

  specify 'User attributes' do
    expect(user).to respond_to(:name)
    expect(user).to respond_to(:name=)

    expect(user).to respond_to(:difficulty)
    expect(user).to respond_to(:difficulty=)

    expect(user).to respond_to(:total_count_attempt)
    expect(user).to respond_to(:total_count_attempt=)

    expect(user).to respond_to(:count_attempt)
    expect(user).to respond_to(:count_attempt=)

    expect(user).to respond_to(:total_count_hints)
    expect(user).to respond_to(:total_count_hints=)

    expect(user).to respond_to(:count_hint)
    expect(user).to respond_to(:count_hint=)
  end

  it 'user  set @name' do
    expect(user.instance_variable_get(:@name)).equal?('Test')
  end

  it 'user  set @difficulty' do
    expect(user.instance_variable_get(:@difficulty)).equal?('easy')
  end

  it 'user  set @total_count_attempt' do
    expect(user.instance_variable_get(:@total_count_attempt)).equal?(15)
  end

  it 'user  set @count_attempt' do
    expect(user.instance_variable_get(:@count_attempt)).equal?(2)
  end

  it 'user  set @total_count_hints' do
    expect(user.instance_variable_get(:@total_count_hints)).equal?(2)
  end

  it 'user  set @count_hint' do
    expect(user.instance_variable_get(:@count_hint)).equal?(0)
  end

   describe 'Statistics' do
     let(:staistics) {Statistics.new}
     specify 'User attributes' do
       expect(staistics).to respond_to(:users)
       expect(staistics).to respond_to(:users=)
     end

     it 'staistics set @users ' do
       expect(staistics.instance_variable_get(:@users).count()).equal?(0)
     end
     it 'staistics set @users ' do
       start_size = staistics.instance_variable_get(:@users).count()
       staistics.add_object(user)
       finish_size = staistics.instance_variable_get(:@users).count()
       expect(finish_size).equal?(start_size + 1)
     end
   end


  #   save_yaml_db
  #   it 'save_yaml_db' do
  #
  #     expect(codebreaker).to receive(:step_close)
  #   end
  #
  #   it 'step_close to receive step_close' do
  #     expect(codebreaker).to receive(:output_exit)
  #     expect(codebreaker).to receive(:exit)
  #   end
  #
  # end
end
