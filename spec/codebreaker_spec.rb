require_relative  'spec_helper'
require_relative  '../dependency'

describe Codebreaker do
  let(:codebreaker) { Codebreaker.new }

  specify 'Codebreaker attributes' do
    expect(codebreaker).to respond_to(:user)
    expect(codebreaker).not_to respond_to(:user=)

    expect(codebreaker).to respond_to(:step)
    expect(codebreaker).not_to respond_to(:step=)

    expect(codebreaker).to respond_to(:game)
    expect(codebreaker).not_to respond_to(:game=)
  end

  describe '#Start' do
    before do
      allow(STDOUT).to receive(:puts).with(anything)
      allow(STDOUT).to receive(:print).with(anything)
      allow(codebreaker).to receive(:loop).and_yield
    end

    after do
      codebreaker.run
    end

    it 'console to receive welcome' do
      expect(codebreaker.instance_variable_get(:@step)).equal?(:welcome)
    end

    it 'console to receive start' do
      expect(codebreaker).to receive(:run)
    end

    describe 'step_welcome' do
      it 'console to receive step_welcome' do
        expect(codebreaker).to receive(:welcome)
      end

      it 'console to receive step_welcome' do
        expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      end

      it 'step_welcome to receive output_welcome' do
        expect(codebreaker).to receive(:output_welcome)
      end
    end

    describe 'step_scenarios' do
      before do
        codebreaker.instance_variable_set(:@step, :scenarios)
      end

      it 'step_scenarios to receive output_scenarios' do
        expect(codebreaker).to receive(:send)
      end

      it 'step_scenarios to receive output_scenarios' do
        expect(codebreaker).to receive(:scenarios)
      end

      it 'step_scenarios to receive output_scenarios' do
        expect(codebreaker).to receive(:output_scenarios)
      end

      it 'console get rules' do
        allow(codebreaker).to receive(:gets).and_return('rules')
        expect(codebreaker.instance_variable_get(:@step)).equal?(:rules)
      end

      it 'console get start' do
        allow(codebreaker).to receive(:gets).and_return('start')
        expect(codebreaker.instance_variable_get(:@step)).equal?(:start)
      end

      it 'console get stats' do
        allow(codebreaker).to receive(:gets).and_return('stats')
        expect(codebreaker.instance_variable_get(:@step)).equal?(:stats)
      end

      # it 'console get game' do
      #   allow(codebreaker).to receive(:gets).and_return('stats')
      #   expect(codebreaker.instance_variable_get(:@step)).equal?('stats')
      # end
    end

    describe 'step_stats' do
      before do
        codebreaker.instance_variable_set(:@step, :stats)
      end

      it 'console to receive step_stats' do
        expect(codebreaker).to receive(:stats)
      end

      it 'step_stats to receive output_stats_table' do
        expect(codebreaker).to receive(:output_stats_table)
      end

      it 'step_stats to receive scenarios' do
        expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      end
    end

    describe 'step_rules' do
      before do
        codebreaker.instance_variable_set(:@step, :rules)
      end

      it 'console to receive step_rules' do
        expect(codebreaker).to receive(:rules)
      end

      it 'step_rules to receive output_rules' do
        expect(codebreaker).to receive(:output_rules)
      end

      it 'step_rules to receive scenarios' do
        expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      end
    end

    describe 'step_start' do
      before do
        codebreaker.instance_variable_set(:@step, :start)
      end

      it 'console to receive step_start' do
        expect(codebreaker).to receive(:start)
      end

      it 'step_start to receive enter_name' do
        expect(codebreaker).to receive(:enter_name)
      end

      # it 'enter_name to receive validtion_name' do
      #   name = 'Amidasd'
      #   allow(codebreaker).to receive(:gets).and_return(name)
      #   expect(codebreaker).to receive(:validtion_name).with(name)
      # end

      it 'enter_name to receive validtion_name' do
        name = 'Amidasd'
        allow(codebreaker).to receive(:gets).and_return(name)
        expect(codebreaker.instance_variable_get(:@name)).equal?(name)
      end

      # it 'enter_name to receive validtion_name = true' do
      #   validtion_name('Amidasd')
      #   # expect(Validation::validtion_name('Amidasd')).equal?(:true)
      # end

      context 'with name' do
        let(:user) { GemCodebreakerAmidasd::User.new(name: 'Amidasd') }
        after do
          codebreaker.instance_variable_set(:@user, user)
        end

        it 'step_start to receive enter_difficulty' do
          expect(codebreaker).to receive(:enter_difficulty)
        end

        it 'enter_difficulty to receive validtion_difficulty' do
          expect(codebreaker).to receive(:valid_difficulty?)
        end

        it 'step_start to receive game' do
          expect(codebreaker.instance_variable_get(:@step)).equal?(:game)
        end
      end
    end

    describe 'step_game' do
      let(:new_game) { GemCodebreakerAmidasd::Game.new }
      before do
        new_game.setDifficulty(:easy)
        codebreaker.instance_variable_set(:@step, :game)
        codebreaker.instance_variable_set(:@game, new_game)
      end

      it 'step_game to receive output_start_game ' do
        expect(codebreaker).to receive(:output_start_game)
      end

      context 'hint' do
        before do
          allow(codebreaker).to receive(:check_exit).and_return('hint')
        end

        it 'step_game to receive gets_hint ' do
          expect(new_game).to receive(:gets_hint)
        end

        it 'step_game to receive output_hint ' do
          expect(codebreaker).to receive(:output_hint).with(new_game)
        end
      end

      context 'guess_code' do
        it 'step_game to receive show_result_code' do
          code = '1111'
          allow(codebreaker).to receive(:gets).and_return(code)
          expect(codebreaker).to receive(:show_result_code).with(code)
        end

        it 'step_game to receive guess_code' do
          code = '1111'
          # allow(codebreaker).to receive(:gets).and_return(code)
          # expect(new_game).to receive(:guess_code).with(code)
         # expect(codebreaker).to receive(:output_guess_code_error).with(new_game)
        end

        it 'step_game to receive output_result_guess_code' do
          new_game.instance_variable_set(:@status, GemCodebreakerAmidasd::STATUS[:process_game])
          expect(codebreaker).to receive(:output_result_guess_code).with(new_game)
        end

        it 'step_game to receive finish' do
          expect(codebreaker.instance_variable_get(:@step)).equal?(:finish)
        end
      end
    end

    describe 'step_finish' do
      let(:new_game) { GemCodebreakerAmidasd::Game.new }

      before do
        new_game.setDifficulty(:easy)
        codebreaker.instance_variable_set(:@step, :finish)
        codebreaker.instance_variable_set(:@game, new_game)
      end

      it 'step_finish to receive output_step_finish ' do
        expect(codebreaker).to receive(:output_step_finish)
      end

      it 'step_finish to receive output_won' do
        new_game.instance_variable_set(:@status, GemCodebreakerAmidasd::STATUS[:win])
        expect(codebreaker).to receive(:output_won)
      end

      it 'step_finish to receive won' do
        new_game.instance_variable_set(:@win, true)
        expect(codebreaker.instance_variable_get(:@step)).equal?(:save)
      end

      it 'step_finish to receive output_lose' do
        new_game.instance_variable_set(:@win, false)
        expect(codebreaker).to receive(:output_lose)
      end

      it 'step_finish to receive empty_game' do
        new_game.instance_variable_set(:@win, false)
        expect(codebreaker).to receive(:empty_game)
      end

      it 'step_finish to receive scenarios' do
        new_game.instance_variable_set(:@win, false)
        expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      end
    end

    describe 'step_save' do
      let(:new_game) { GemCodebreakerAmidasd::Game.new }

      # let(:user) { GemCodebreakerAmidasd::User.new(name: "Amidasd") }

      before do
        new_game.setDifficulty(:easy)
        # user.set_params(difficulty: new_game.difficulty, total_count_attempt: new_game.total_count_attempt,
        #                 count_attempt: new_game.count_attempt, total_count_hints: new_game.total_count_hints,
        #                 count_hint: new_game.array_hints.size)
        codebreaker.instance_variable_set(:@step, :save)
        codebreaker.instance_variable_set(:@game, new_game)
      end

      it 'step_save to receive output_save ' do
        expect(codebreaker).to receive(:output_save)
      end

      it 'step_save to receive check_exit ' do
        expect(codebreaker).to receive(:check_exit)
      end

      it 'step_save to receive yes ' do
        allow(codebreaker).to receive(:gets).and_return(I18n.t('Game.y'))
        expect(codebreaker).to receive(:save_game)
      end

      # it 'step_save to receive scenarios ' do
      #   allow(codebreaker).to receive(:gets).and_return(I18n.t('Game.y'))
      #   # DbUtility.add_db(user)
      #   # GemCodebreakerAmidasd::DbUtility.add_db(user, PATH_DB)
      #   expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      # end

      it 'step_save to receive no ' do
        allow(codebreaker).to receive(:gets).and_return(I18n.t('Game.n'))
        expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      end

      it 'step_save to receive empty_game ' do
        expect(codebreaker).to receive(:empty_game)
        expect(codebreaker.instance_variable_get(:@game)).equal?(nil)
        expect(codebreaker.instance_variable_get(:@name)).equal?(nil)
        expect(codebreaker.instance_variable_get(:@difficulty)).equal?(nil)
      end
    end

    describe 'step_else' do
      before do
        codebreaker.instance_variable_set(:@step, :step_else)
      end

      it 'console to receive step_else' do
        expect(codebreaker).to receive(:step_else)
      end

      it 'step_rules to receive output_else' do
        expect(codebreaker).to receive(:output_else)
      end

      it 'step_rules to receive scenarios' do
        expect(codebreaker.instance_variable_get(:@step)).equal?(:scenarios)
      end
    end

    describe 'close' do
      before do
        codebreaker.instance_variable_set(:@step, :exit)
      end

      it 'step_close to receive step_close' do
        expect(codebreaker).to receive(:close)
      end

      it 'step_close to receive step_close' do
        expect(codebreaker).to receive(:output_exit)
        expect(codebreaker).to receive(:exit)
      end
    end
  end
end
