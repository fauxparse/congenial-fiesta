class RemovePaymentsSti < ActiveRecord::Migration[5.2]
  def up
    add_column :payments, :kind, :string,
      limit: 32, required: true, default: PaymentMethod.kinds.first
    %w[internet_banking pay_pal].each do |kind|
      Payment.where(kind: "Payment::#{kind.camelize}").update_all(type: kind)
    end
    remove_column :payments, :type
  end

  def down
    add_column :payments, :type, :string
    %w[internet_banking pay_pal].each do |kind|
      Payment.where(kind: kind).update_all(type: "Payment::#{kind.camelize}")
    end
    remove_column :payments, :kind
  end
end
