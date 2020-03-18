library(ggplot2)

#define a helper function (borrowed from the "ez" package)
ezLev=function(x,new_order){
	for(i in rev(new_order)){
		x=relevel(x,ref=i)
	}
	return(x)
}

ggcorplot = function(data,cor_text_limits){
	#normalize data
	for(i in 1:length(data)){
		data[,i]=(data[,i]-mean(data[,i]))/sd(data[,i])
	}
	#obtain new data frame
	z=data.frame()
	i = 1
	j = i
	while(i<=length(data)){
		if(j>length(data)){
			i=i+1
			j=i
		}else{
			x = data[,i]
			y = data[,j]
			temp=as.data.frame(cbind(x,y))
			temp=cbind(temp,names(data)[i],names(data)[j])
			z=rbind(z,temp)
			j=j+1
		}
	}
	names(z)=c('x','y','x_lab','y_lab')
	z$x_lab = ezLev(factor(z$x_lab),names(data))
	z$y_lab = ezLev(factor(z$y_lab),names(data))
	z=z[z$x_lab!=z$y_lab,]
	#obtain correlation values
	z_cor = data.frame()
	i = 1
	j = i
	while(i<=length(data)){
		if(j>length(data)){
			i=i+1
			j=i
		}else{
			x = data[,i]
			y = data[,j]
			this_cor = round(cor(x,y),2)
			this_cor.test = cor.test(x,y)
			this_col = ifelse(this_cor.test$p.value<.05,'<.05','>.05')
			this_size = (this_cor)^2
			cor_text = ifelse(
				this_cor==1
				, '1'
				, ifelse(
					this_cor>0
					,substr(format(c(this_cor,.123456789),digits=2)[1],2,4)
					,paste('-',substr(format(c(this_cor,.123456789),digits=2)[1],3,5),sep='')
				)
			)
			b=as.data.frame(cor_text)
			b=cbind(b,this_col,this_size,names(data)[j],names(data)[i])
			z_cor=rbind(z_cor,b)
			j=j+1
		}
	}
	names(z_cor)=c('cor','p','rsq','x_lab','y_lab')
	z_cor$p = factor(z_cor$p)
	z_cor$x_lab = ezLev(factor(z_cor$x_lab),names(data))
	z_cor$y_lab = ezLev(factor(z_cor$y_lab),names(data))
	z_cor=z_cor[z_cor$x_lab!=z_cor$y_lab,]
	diag = melt.data.frame(data)
	names(diag)[1] = 'x_lab'
	diag$y_lab = diag$x_lab
	diag = ddply(
		diag
		, .(x_lab,y_lab)
		, function(x){
			d = density(x$value)
			d = data.frame(x=d$x,y=d$y)
			d$y = d$y*((max(x$value)-min(x$value))/max(d$y))
			d$y = d$y + min(x$value)
			return(d)
		}
	)
	#start creating layers
	points_layer = layer(
		geom = 'point'
		, data = z
		, mapping = aes(
			x = x
			, y = y
		)
	)
	lm_line_layer = layer(
		geom = 'line'
		, geom_params = list(colour = 'red')
		, stat = 'smooth'
		, stat_params = list(method = 'lm')
		, data = z
		, mapping = aes(
			x = x
			, y = y
		)
	)
	lm_ribbon_layer = layer(
		geom = 'ribbon'
		, geom_params = list(fill = 'green', alpha = .5)
		, stat = 'smooth'
		, stat_params = list(method = 'lm')
		, data = z
		, mapping = aes(
			x = x
			, y = y
		)
	)
	cor_text = layer(
		geom = 'text'
		, data = z_cor
		, mapping = aes(
			x=0
			, y=0
			, label=cor
			, size = rsq
			, colour = p
		)
	)
	diagonal = layer(
		geom = 'line'
		, data = diag
		, mapping = aes(
			x=x
			, y = y
		)
	)
	f = facet_grid(y_lab~x_lab)
	o = opts(
		panel.grid.minor = theme_blank()
		,panel.grid.major = theme_blank()
		,axis.ticks = theme_blank()
		,axis.text.y = theme_blank()
		,axis.text.x = theme_blank()
		,axis.title.y = theme_blank()
		,axis.title.x = theme_blank()
		,legend.position='none'
	)
	x_scale = scale_x_continuous(limits = c( -1*max(abs(c(z$x,z$y))) , max(abs(c(z$x,z$y))) ) )
	y_scale = scale_y_continuous(limits = c( -1*max(abs(c(z$x,z$y))) , max(abs(c(z$x,z$y))) ) )
	size_scale = scale_size(limits = c(0,1),to=cor_text_limits)
	return(
		ggplot(z_cor)+
		points_layer+
		lm_ribbon_layer+
		lm_line_layer+
		diagonal+
		cor_text+
		f+
		o+
		x_scale+
		y_scale+
		size_scale
	)
}

########
# Usage example
########
##set up some fake data
#library(MASS)
#N=100
#
##first pair of variables
#variance1=1
#variance2=2
#mean1=10
#mean2=20
#rho = .8
#Sigma=matrix(c(variance1,sqrt(variance1*variance2)*rho,sqrt(variance1*variance2)*rho,variance2),2,2)
#pair1=mvrnorm(N,c(mean1,mean2),Sigma,empirical=T)
#
##second pair of variables
#variance1=10
#variance2=20
#mean1=100
#mean2=200
#rho = -.4
#Sigma=matrix(c(variance1,sqrt(variance1*variance2)*rho,sqrt(variance1*variance2)*rho,variance2),2,2)
#pair2=mvrnorm(N,c(mean1,mean2),Sigma,empirical=T)
#
#my_data=data.frame(cbind(pair1,pair2))
#
#ggcorplot(
#	data = my_data
#	, cor_text_limits = c(2,30)
#)
