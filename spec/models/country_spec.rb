require 'spec_helper'

describe Country do

    # ActiveRecord
    it { expect(subject).to have_many(:destinations).dependent(:delete_all) }
    it { expect(subject).to have_many(:shippings).through(:destinations) }

    #Validations
    it { expect(subject).to validate_presence_of(:name) }
    
    it { expect(subject).to validate_uniqueness_of(:name) }

end