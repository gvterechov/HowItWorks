module TaskStatisticHelper
  def task_result_in(attempt)
    all_attempts =
      attempt.task
             .attempts
             .pluck(:total_steps)
             .uniq
             .sort

    rating = all_attempts.index(attempt.total_steps) * 100 / all_attempts.count

    case rating
      when 0
        t('task_statistic.best_result')
      when 1..40
        t('task_statistic.result_in', percent: rating)
      when 40..60
        t('task_statistic.average_result')
      else
        t('task_statistic.bad_result')
    end
  end

  def task_total_steps(attempt, best_attempt)
    total_steps = attempt.total_steps
    min_steps = best_attempt.total_steps
    delta = total_steps - min_steps

    result = t('task_statistic.steps_count', steps: total_steps)
    result += " (#{t('task_statistic.steps_from_best', steps: delta)})" if delta > 0
    result
  end

  def task_error_steps(attempt, best_attempt)
    error_steps = attempt.error_steps
    min_error_steps = best_attempt.error_steps
    delta = error_steps - min_error_steps

    result = t('task_statistic.error_steps_count', steps: error_steps)
    result += " (#{t('task_statistic.steps_from_best', steps: delta)})" if delta > 0
    result
  end
end
