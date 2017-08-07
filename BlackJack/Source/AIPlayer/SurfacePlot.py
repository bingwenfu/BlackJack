import plotly
import plotly.plotly as py
from plotly.graph_objs import *

import matplotlib
matplotlib.use('TkAgg')  
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def plotly_surface(x,y,z):
	plotly.tools.set_credentials_file(username='bingwen', api_key='FogKyVPdxmhu0NaD6X2B')
	trace = {
	 "autocolorscale": False, 
	  "cauto": False, 
	  "cmax": 0.9, 
	  "cmin": 0.1, 
	  "colorscale": [
	    [0, "rgb(0,0,155)"], [0.35, "rgb(0,108,255)"], [0.5, "rgb(98,255,146)"], [0.6, "rgb(255,147,0)"], [0.7, "rgb(255,47,0)"], [1, "rgb(216,0,0)"]], 
	  "lighting": {
	    "ambient": 0.72, 
	    "diffuse": 0.62, 
	    "fresnel": 0.6, 
	    "roughness": 0.47, 
	    "specular": 0.08
	  }, 
	  "lightposition": {
	    "x": 0, 
	    "y": 0, 
	    "z": 0
	  }, 
	  "name": "", 
	  "reversescale": False, 
	  "showlegend": True, 
	  "showscale": True, 
	  "type": "surface", 
	  "uid": "69842b", 
	  "visible": True, 
	  "xsrc": "bingwen:25:b62c3b", 
	  "ysrc": "bingwen:25:6478c7", 
	  "zmax": 1, 
	  "zmin": -0.217229, 
	  "zsrc": "bingwen:25:-6478c7,b62c3b"
	}

	tmp = {"x": x, "y": y, "z": z}
	trace.update(tmp)

	layout = {
	  "autosize": True, 
	  "scene": {
	    "aspectratio": {
	      "x": 1, 
	      "y": 1, 
	      "z": 1
	    }, 
	    "camera": {
	      "center": {
	        "x": -0.0267791531978, 
	        "y": -0.0102552804014, 
	        "z": -0.0934510815692
	      }, 
	      "eye": {
	        "x": -0.997055307948, 
	        "y": -1.93091357225, 
	        "z": 0.665369915867
	      }, 
	      "up": {
	        "x": 0, 
	        "y": 0, 
	        "z": 1
	      }
	    }, 
	    "dragmode": "turntable"
	  }
	}
	data = Data([trace])
	fig = Figure(data=data, layout=layout)
	plot_url = py.plot(fig)


def matplot_surface(X, Y, Z, title):
	print title
	fig = plt.figure(figsize=(12, 7))
	ax = fig.add_subplot(111, projection='3d')
	surf = ax.plot_surface(X, Y, Z, rstride=1, cstride=1,cmap=matplotlib.cm.coolwarm, vmin=0, vmax=1.0)
	ax.set_xlabel('Player Sum')
	ax.set_ylabel('Dealer Showing')
	ax.set_zlabel('P(win)')
	ax.set_title(title)
	ax.view_init(ax.elev, -120)
	fig.colorbar(surf)
	plt.show()
    # ax.scatter(X, Y, Z)
    # ax.plot_wireframe(X, Y, Z)
    # cset = ax.contourf(X, Y, Z, zdir='z', offset=0.1, cmap=matplotlib.cm.coolwarm)

