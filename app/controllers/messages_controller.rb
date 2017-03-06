# questionable

class MessagesController < ApplicationController
  
  before_action :set_conversation
  
  def index
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
      @messages = @conversation.messages.order("created_at DESC")
      
      if @messages.exists? 
        if @conversation.messages.last.user_id == @other.id
          @conversation.update_attribute(:latest_message_read, true)
          @conversation.save
        end
      end
      
      # if @messages.last.recipient_id == current_user.id
      #   @messages.where(read_at: nil).each do |message|
      #     message.update_attributes(read_at: Time.now)
      #     message.save
      #   end
      # end

      # def show
      #     @message = Message.find(params[:id])
      #     if @message.recipient_id == current_user.id
      #       @message.update_attributes(:read_at => Time.now)
      #     end
      #     respond_to do |format|
      #       format.html # show.html.erb
      #       format.xml  { render :xml => @message }
      #     end
      #   end

    else
      redirect_to conversations_path, alert: "Access denied"
    end
  end
  
  def create
    @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
    @message  = @conversation.messages.new(message_params)
    @messages = @conversation.messages.order("created_at DESC")

    if @message.save
      @conversation.update_attributes(next_contributor_id: @other.id,
                                      latest_message_read: false)
      @conversation.save
      respond_to do |format|
        format.js
      end
    end
  end
  
  def accept
    @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
    appointment = @conversation.appointments.where(status: 'pending').first
    appointment.update_attribute(:status, 'accepted')
    @conversation.update_attribute(:next_contributor_id, @other.id)
    # AppointmentMailer.appointment_accepted(appointment).deliver_now
    flash[:success] = "Test drive accepted!"
    redirect_to :back
  end
  
  def decline
    @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
    appointment = @conversation.appointments.where(status: 'pending').first
    appointment.update_attribute(:status, 'declined')
    @conversation.update_attribute(:next_contributor_id, @other.id)
    # AppointmentMailer.appointment_declined(appointment).deliver_now
    flash[:failure] = "Test drive declined."
    redirect_to :back
  end

  private
  
    def message_params
      params.require(:message).permit(:content, :user_id)
    end
      
    # Before filters
    
    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end
end