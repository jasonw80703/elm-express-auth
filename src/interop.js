export const flags = ({ env }) => {
  // Called before our Elm application starts
  console.log("token: ",window.localStorage.token)
  console.log("user: ",window.localStorage.user)
  return {
    token: JSON.parse(window.localStorage.token || null),
    user: JSON.parse(window.localStorage.user || null)
  }
};

export const onReady = ({ env, app }) => {
  // Called after our Elm application starts
  if (app.ports && app.ports.sendToLocalStorage) {
    app.ports.sendToLocalStorage.subscribe(({ key, value }) => {
      window.localStorage[key] = JSON.stringify(value)
    })
  }
};