namespace :db do
  namespace :seed do
    task measures: :environment do
      WegoauditDataImporter.new.import_entities(:measures)
    end

    task structure_types: :environment do
      WegoauditDataImporter.new.import_entities(:structure_types)
    end

    task fields: :environment do
      WegoauditDataImporter.new.import_entities(:fields)
    end
  end
end
