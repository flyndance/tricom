class Setsubiyoyaku < ActiveRecord::Base
  self.table_name = :設備予約

  validates :設備コード, :開始, :終了, presence: true

  belongs_to :setsubi, foreign_key: :設備コード
  belongs_to :shainmaster, foreign_key: :予約者
  belongs_to :kaishamaster, foreign_key: :相手先

  validate :check_date_input

  private
  def check_date_input
    if 開始.present? && 終了.present? && 開始 >= 終了
      errors.add(:終了, (I18n.t 'app.model.check_data_input'))
    end
    # if is update the id it not nil then the old_setsubiyoyaku is exist
    if !self.id.nil?
      old_setsubiyoyaku=Setsubiyoyaku.find self.id
    end
    @setsubiyoyaku = Setsubiyoyaku.where 設備コード: 設備コード
    @setsubiyoyaku.each do |setsubiyoyaku|
      # if is update the id it not nil then check some thing changed ?
      if self.id != setsubiyoyaku.id
        if !self.id.nil?
          # check 設備コード is changed? or 開始 changed ? or 終了 changed ?
          # if there changed then check the 開始, 終了 are right ?
          if 設備コード != old_setsubiyoyaku.設備コード || 開始 != old_setsubiyoyaku.開始 || 終了 != old_setsubiyoyaku.終了
            unless 開始 >= setsubiyoyaku.終了 || 終了 <= setsubiyoyaku.開始
              errors.add(:設備コード, (I18n.t 'app.model.schedule'))
            end
          end
        else
          # if is new the id is nil
          # then check if there changed then check the 開始, 終了 are right ?
          unless 開始 >= setsubiyoyaku.終了 || 終了 <= setsubiyoyaku.開始
            errors.add(:設備コード, (I18n.t 'app.model.schedule'))
          end
        end
      end
    end
  end
end
