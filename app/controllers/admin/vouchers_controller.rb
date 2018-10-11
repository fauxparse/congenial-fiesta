# frozen_string_literal: true

module Admin
  class VouchersController < Controller
    def index
      authorize Voucher
    end

    def show
      authorize voucher
    end

    def new
      authorize Voucher
      @voucher = Voucher.new
    end

    def create
      authorize Voucher
      @voucher = Voucher.new(voucher_params)
      if @voucher.save
        redirect_to admin_vouchers_path(festival), notice: t('.created')
      else
        flash.now[:error] = t('.error')
        render :new
      end
    end

    def update
      authorize voucher
      if voucher.update(voucher_params)
        redirect_to admin_vouchers_path(festival), notice: t('.updated')
      else
        flash.now[:error] = t('.error')
        render :show
      end
    end

    def destroy
      authorize voucher
      voucher.destroy
      redirect_to admin_vouchers_path(festival), notice: t('.deleted')
    end

    private

    def vouchers
      @vouchers ||=
        Voucher
          .includes(registration: :participant)
          .references(:registrations)
          .where('registrations.festival_id = ?', festival.id)
    end

    def voucher
      @voucher ||= vouchers.find_by_hashid(params[:id])
    end

    def voucher_params
      params
        .require(:voucher)
        .permit(:registration_id, :workshop_count, :note)
    end

    helper_method :vouchers, :voucher
  end
end
