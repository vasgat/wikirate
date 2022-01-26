delegate :calculator, :normalize_value, to: :left # left is metric

# often overwritten in metric
def calculator_class
  if javascript_formula?
    ::Calculate::JavaScript
  else
    ::Calculate.calculator_class parser.formula
  end
end

event :update_calculated_answers, :integrate_with_delay, priority: 5,
      on: :save, changed: :content, when: :content? do
  metric_card.deep_answer_update
end
