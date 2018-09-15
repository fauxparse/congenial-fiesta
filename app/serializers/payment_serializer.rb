# frozen_string_literal: true

class PaymentSerializer < Primalize::Single
  attributes(
    id: string,
    name: string,
    amount: primalize(MoneySerializer),
    state: string,
    kind: string,
    time: timestamp,
    reference: optional(string)
  )

  def id
    object.to_param
  end

  def name
    object.registration.participant.name
  end

  def kind
    I18n.t(object.kind, scope: 'payment.methods')
  end

  def time
    object.created_at
  end
end
