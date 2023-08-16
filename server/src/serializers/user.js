const userSerializer = (user) => ({
  id: user._id,
  username: user.username,
  name: user.name,
  createdAt: user.createdAt,
  updatedAt: user.updatedAt,
});

export default userSerializer;
