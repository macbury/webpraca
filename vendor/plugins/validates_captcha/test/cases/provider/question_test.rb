require 'test_helper'

QUESTION = ValidatesCaptcha::Provider::Question

class QuestionTest < ValidatesCaptcha::TestCase
  test "defines a class level #questions_and_answers method" do
    assert_respond_to QUESTION, :questions_and_answers
  end

  test "defines a class level #questions_and_answers= method" do
    assert_respond_to QUESTION, :questions_and_answers=
  end

  test "#questions_and_answers method's return value should equal the value set using the #questions_and_answers= method" do
    old_questions_and_answers = QUESTION.questions_and_answers

    QUESTION.questions_and_answers = 'abc'
    assert_equal 'abc', QUESTION.questions_and_answers

    QUESTION.questions_and_answers = old_questions_and_answers
  end

  test "calling #call with unrecognized path should have response status 404" do
    result = QUESTION.new.call 'PATH_INFO' => '/unrecognized'

    assert_equal 404, result.first
  end

  test "calling #call with regenerate path should have response status 200" do
    result = QUESTION.new.call 'PATH_INFO' => QUESTION.new.send(:regenerate_path)

    assert_equal 200, result.first
  end

  test "calling #call with regenerate path should have content type response header set to application/json" do
    result = QUESTION.new.call 'PATH_INFO' => QUESTION.new.send(:regenerate_path)

    assert result.second.key?('Content-Type')
    assert_equal 'application/json', result.second['Content-Type']
  end
end

