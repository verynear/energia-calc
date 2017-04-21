class AccessLevel
  OWN = 'own'
  EDIT = 'edit'
  VIEW = 'view'
  REFERENCE = 'reference'
  ALL = [REFERENCE, VIEW, EDIT, OWN]
  CAN_VIEW = [VIEW, EDIT, OWN]
  CAN_EDIT = [EDIT, OWN]
  SHARED = [VIEW, EDIT]
end
