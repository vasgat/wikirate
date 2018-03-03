# <OVERRIDES>
# note: the following only _really_ apply to calculated metrics and should arguably
# be in Abstract::Calculation.  However that breaks an API test that assumes formulas
# can be run on _any_ metric. If we're ok to remove that api, I'm happy to move this code
# -efm
def formula_editor
  :standard_formula_editor
end

def formula_core
  nil
end

def calculator_class
  nil
end
# </OVERRIDES>

# @return all metric cards that score this metric
def each_dependent_score_metric
  dependent_score_metrics.each do |m|
    yield m
  end
end

def each_dependent_formula_metric
  DependencyTree.new(directly_dependent_formula_metrics).each_metric do |m|
    yield m
  end
end

def dependent_score_metrics
  Card.search type_id: MetricID, left_id: id
end

def directly_dependent_formula_metrics
  @dependents ||=
    Card.search type_id: MetricID, right_plus: ["formula", { refer_to: id }]
end
