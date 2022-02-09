export const closeOpenNavbarDropdown = () => {
  const navbar = UIkit.navbar('.main-navbar')
  const activeDropdown = navbar.getActive()
  if (!activeDropdown) { return }

  activeDropdown.$el.classList.remove('uk-open')
}
