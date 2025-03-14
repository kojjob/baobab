class StandardizeStatusFields < ActiveRecord::Migration[8.0]
  def up
    # Add a temporary column to store the new integer status
    add_column :orders, :status_temp, :integer, default: 0

    # Update the temporary column with the converted values
    reversible do |dir|
      dir.up do
        Order.find_each do |order|
          order.update_column(:status_temp, order.status.to_i)
        end
      end

      dir.down do
        Order.find_each do |order|
          order.update_column(:status, order.status_temp.to_s)
        end
      end
    end

    # Remove the old status column and rename the temporary column
    remove_column :orders, :status
    rename_column :orders, :status_temp, :status

    # Repeat the process for payment_status
    add_column :orders, :payment_status_temp, :integer, default: 0

    reversible do |dir|
      dir.up do
        Order.find_each do |order|
          order.update_column(:payment_status_temp, order.payment_status.to_i)
        end
      end

      dir.down do
        Order.find_each do |order|
          order.update_column(:payment_status, order.payment_status_temp.to_s)
        end
      end
    end

    remove_column :orders, :payment_status
    rename_column :orders, :payment_status_temp, :payment_status

    # Add indexes for the new columns
    add_index :orders, :status
    add_index :orders, :payment_status
  end

  def down
    # Remove indexes
    remove_index :orders, :status
    remove_index :orders, :payment_status

    # Reverse the column changes
    rename_column :orders, :status, :status_temp
    add_column :orders, :status, :string
    rename_column :orders, :payment_status, :payment_status_temp
    add_column :orders, :payment_status, :string

    # Update the columns with the original values
    reversible do |dir|
      dir.down do
        Order.find_each do |order|
          order.update_column(:status, order.status_temp.to_s)
          order.update_column(:payment_status, order.payment_status_temp.to_s)
        end
      end

      dir.up do
        Order.find_each do |order|
          order.update_column(:status_temp, order.status.to_i)
          order.update_column(:payment_status_temp, order.payment_status.to_i)
        end
      end
    end

    remove_column :orders, :status_temp
    remove_column :orders, :payment_status_temp
  end
end
