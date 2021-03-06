# Preview all emails at http://localhost:3000/rails/mailers/appointment_mailer
class AppointmentMailerPreview < ActionMailer::Preview

  # Preview this email at 
  # http://localhost:3000/rails/mailers/appointment_mailer/appointment_request
  def appointment_request
    appointment = Appointment.first
    AppointmentMailer.appointment_request(appointment)
  end
  
  # Preview this email at 
  # http://localhost:3000/rails/mailers/appointment_mailer/appointment_accepted
  def appointment_accepted
    appointment = Appointment.first
    AppointmentMailer.appointment_accepted(appointment)
  end
  
  # Preview this email at 
  # http://localhost:3000/rails/mailers/appointment_mailer/appointment_declined
  def appointment_declined
    appointment = Appointment.first
    AppointmentMailer.appointment_declined(appointment)
  end
  
  # Preview this email at 
  # http://localhost:3000/rails/mailers/appointment_mailer/review_request
  def review_request
    appointment = Appointment.first
    AppointmentMailer.review_request(appointment)
  end
end
