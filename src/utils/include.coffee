base_dir = __dirname
abs_path = (path) -> base_dir + "/../" + path

#include files from root.
global.include = (file) -> require abs_path "/" + file