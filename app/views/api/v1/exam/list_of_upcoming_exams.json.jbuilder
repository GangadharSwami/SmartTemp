unless @upcoming_exams.empty?
  json.upcoming_exams @upcoming_exams  
else
  json.message "No upcoming exams"
end
