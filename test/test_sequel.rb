require '../app'
require 'test/unit'

TEST_DB = Sequel.sqlite

class SequelProgressBarTest < Test::Unit::TestCase
  SleepUnit = 0.01

  def do_make_progress_bar (title, total)
    pseudo_id = rand(10**5)
    DbProgressBar.new(title, total, SequelOutput.new(pseudo_id, TEST_DB))
  end

  def test_bytes
    total = 1024 * 1024
    pbar = do_make_progress_bar("test(bytes)", total)
    pbar.file_transfer_mode
    0.step(total, 2**14) {|x|
      pbar.set(x)
      sleep(SleepUnit)
    }
    pbar.finish
    assert pbar.get_progress_text =~ /\|(o){80}\|/
    assert_equal 100, pbar.get_progress_percent
  end

  def test_clear
    total = 100
    pbar = do_make_progress_bar("test(clear)", total)
    total.times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.clear
    assert_equal "", pbar.get_progress_text
    assert_equal 0, pbar.get_progress_percent
  end
  
  def test_halt
    total = 100
    pbar = do_make_progress_bar("test(halt)", total)
    (total / 2).times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.halt
    assert pbar.get_progress_text =~ / 50% /
    assert pbar.get_progress_text =~ /\|(o){40}(\s){40}\|/
    assert_equal 50, pbar.get_progress_percent
  end
  
  def test_inc
    total = 100
    pbar = do_make_progress_bar("test(inc)", total)
    total.times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.finish
    assert pbar.get_progress_text =~ /\|(o){80}\|/
    assert_equal 100, pbar.get_progress_percent
  end
  
  def test_invalid_set
    total = 100
    pbar = do_make_progress_bar("test(invalid set)", total)
    begin
      pbar.set(200)
    rescue RuntimeError => e
      assert_equal "invalid count: 200 (total: 100)", e.message
    end
  end
  
  def test_set
    total = 1000
    pbar = do_make_progress_bar("test(set)", total)
    (1..total).find_all {|x| x % 10 == 0}.each {|x|
      sleep(SleepUnit)
      pbar.set(x)
    }
    pbar.finish
    assert pbar.get_progress_text =~ /\|(o){80}\|/
    assert_equal 100, pbar.get_progress_percent
  end
  
  def test_total_zero
    total = 0
    pbar = do_make_progress_bar("test(total=0)", total)
    pbar.finish
    assert pbar.get_progress_text =~ /\|(o){80}\|/
    assert pbar.get_progress_text =~ /total/
    assert_equal 100, pbar.get_progress_percent
  end
  
  def test_alternate_bar
    total = 100
    pbar = do_make_progress_bar("test(alternate)", total)
    pbar.bar_mark = "="
    total.times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.finish
    assert pbar.get_progress_text =~ /\|(=){80}\|/
    assert_equal 100, pbar.get_progress_percent
  end
end


