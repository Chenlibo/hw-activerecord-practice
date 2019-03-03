require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    where('first = ?', :Candice)
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    where("email LIKE ?", "%@%")
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    where("email LIKE ?", "%.org")
  end

  def self.with_invalid_email
    where("email IS NOT NULL and email NOT LIKE ?", "%@%")
  end

  def self.with_blank_email
    where("email IS NULL")
  end

  def self.born_before_1980
    where("birthdate < ?", '1980-01-01')
  end

  def self.with_valid_email_and_born_before_1980
    where("birthdate < ?", '1980-01-01').where("email LIKE ?", "%@%")
  end

  def self.twenty_youngest
    order('birthdate DESC').limit(20)
  end

  def self.last_names_starting_with_b
    where('last LIKE ?', 'B%').order('birthdate')
  end

  def self.update_gussie_murray_birthdate
    gussie_murray = where('first = ? AND last = ?', 'Gussie', 'Murray')
    gussie_murray.update_all(birthdate: Time.parse('2004-02-08'))
  end

  def self.change_all_invalid_emails_to_blank
    with_invalid_email.update_all(email: nil)
  end

  def self.delete_meggie_herman
    maggie_herman = where('first = ? AND last = ?', 'Meggie', 'Herman')
    maggie_herman.delete_all
  end

  def self.delete_everyone_born_before_1978
    everyone_born_before_1978 = where('birthdate < ?', '1978-01-01')
    everyone_born_before_1978.delete_all
  end
end
