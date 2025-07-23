env :TZ, "America/Sao_Paulo"

every 1.day, at: "10:00 am" do
  runner "SendDebtRemindersJob.perform_later"
end
