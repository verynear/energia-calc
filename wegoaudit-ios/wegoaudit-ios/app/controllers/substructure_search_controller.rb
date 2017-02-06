class SubstructureSearchController < UITableViewController
  extend IB

  attr_accessor :structure, :structure_type

  outlet :searchBar, UISearchBar

  def viewDidLoad
    self.title = "#{structure_type.name} Search"
    searchBar.delegate = self
    searchBar.placeholder = no_search_text_message
    @search_results = []
    @row_selected = false
  end

  def viewWillDisappear(animated)
    clear_notifications
    super
  end

  def dealloc
    clear_notifications
    super
  end

  def searchBarSearchButtonClicked(search_bar)
    @search_results = nil
    search_bar.resignFirstResponder
    navigationItem.title = "Search results for '#{search_bar.text}'"
    search_for(search_bar.text)
    search_bar.text = ""
    searchBar.placeholder = search_result_text
  end

  def search_for(search_text)
    @last_search_text = search_text
    @search_results = structure_type.find_all_by_name(search_text)
    view.reloadData
  end

  ## Table view data source

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
   @search_results.to_a.length
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= 'substructureSearchResultCell'
    cell = tableView.dequeueReusableCellWithIdentifier('substructureSearchResultCell')

    cell.name.text = @search_results[indexPath.row].search_result_description
    cell
  end


  ## Table view delegate

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    unless @row_selected
      @row_selected = true
      selected_building = @search_results[indexPath.row]

      if structure.structure_type == structure_type
        link_building(selected_building)
      else
        clone_building(selected_building)
      end
    end
  end

  def clone_building(selected_building)
    if selected_building.structure.full_download_on
      StructureCloneService.execute!(
        structure: selected_building.structure,
        params: { parent_structure_id: structure.id })
      save_and_close
    else
      BW::NetworkIndicator.show
      add_download_complete_observer
      FullStructureDownloadService.execute(
        structure_id: selected_building.structure.id,
        clone_into_structure_id: structure.id)
    end
  end

  def link_building(selected_building)
    if selected_building.structure.full_download_on
      AttributeCopierService.execute!(
        from: selected_building,
        to: structure.physical_structure)
      save_and_close
    else
      BW::NetworkIndicator.show
      add_download_complete_observer
      FullStructureDownloadService.execute(
        structure_id: selected_building.structure.id,
        copy_attributes_to: structure.physical_structure)
    end
  end

  def save_and_close
    cdq.save
    close_popover
  end

  def close_popover
    NSNotificationCenter
      .defaultCenter
      .postNotificationName('dismissPopover', object: self)
  end

  def add_download_complete_observer
      NSNotificationCenter.defaultCenter.addObserver(
      self,
      selector: 'download_complete',
      name: 'fullStructureDownloadComplete',
      object: nil)
  end

  def clear_notifications
    NSNotificationCenter.defaultCenter.removeObserver(
      self,
      name: 'fullStructureDownloadComplete')
  end

  def download_complete
    BW::NetworkIndicator.hide
    save_and_close
  end

  def no_search_text_message
    count = structure_type.uncloned_count
    "There are #{count} #{structure_type.name.downcase}(s). Enter search text."
  end

  def search_result_text
    "#{@search_results.count} #{structure_type.name.downcase}(s) found for search text '#{@last_search_text}'"
  end
end
