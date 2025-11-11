module ApplicationHelper
  def currency(amount_cents)
    number_to_currency(
      amount_cents.to_i / 100.0,
      unit: "Rs.",
      precision: 0,
      delimiter: ","
    )
  end

  def flash_class(key)
    {
      notice: "bg-emerald-100 text-emerald-900 border-emerald-200",
      alert: "bg-rose-100 text-rose-900 border-rose-200"
    }.fetch(key.to_sym, "bg-slate-100 text-slate-900 border-slate-200")
  end
end
