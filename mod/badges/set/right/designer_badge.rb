include_set Abstract::AnswerCreateAffinityBadge

format :html do
  view :description do
    "Awarded for adding #{threshold} answer for metrics designed by #{affinity}"
  end
end

def affinity_type
  :designer
end
